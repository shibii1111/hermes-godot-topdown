extends Node2D
class_name DungeonRoot

## Runs a generated branching dungeon for the current roguelite run.
## It owns graph traversal, active room swapping, player placement, and run reward payout.

const DungeonGeneratorScript := preload("res://scripts/dungeon/dungeon_generator.gd")

@onready var active_room_container: Node2D = %ActiveRoomContainer
@onready var player: Node = %Player
@onready var hud: Node = %HUD
@onready var pause_menu: Node = %PauseMenu
@onready var inventory_menu: Node = %InventoryMenu
@onready var special_indicator: Node = %SpecialIndicator
@onready var room_counter_label: Label = %RoomCounterLabel
@onready var room_type_label: Label = %RoomTypeLabel
@onready var return_hub_button: Button = %ReturnHubButton

var dungeon_graph: Dictionary = {}
var current_room_id: String = ""
var active_room: Node = null
var run_currency: int = 0
var run_xp: int = 0
var run_level: int = 1
var xp_required: int = 10
var transition_in_progress: bool = false


## Starts a generated run and wires shared run UI.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	pause_menu.resume_requested.connect(_resume_from_pause)
	pause_menu.return_hub_requested.connect(func() -> void: complete_run("manual_return"))
	inventory_menu.close_requested.connect(_resume_from_inventory)
	return_hub_button.pressed.connect(func() -> void: complete_run("manual_return"))
	_on_player_health_changed(player.health_component.current_health, player.health_component.max_health)
	_update_currency_label()
	_update_xp_label()
	generate_dungeon(Time.get_unix_time_from_system())


## Handles run UI shortcuts while leaving player combat input inside player components.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause_menu()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("inventory"):
		toggle_inventory_menu()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("special") and not get_tree().paused:
		trigger_special_ui()
		get_viewport().set_input_as_handled()


## Builds a new dungeon graph and loads its start room.
func generate_dungeon(seed_value: int = 0) -> void:
	var generator = DungeonGeneratorScript.new()
	dungeon_graph = generator.generate(seed_value)
	current_room_id = String(dungeon_graph.get("start_room_id", ""))
	_load_current_room("")


## Moves to the neighbor room connected by the requested cardinal direction.
func transition_to_neighbor(direction: String) -> void:
	if transition_in_progress:
		return
	transition_in_progress = true
	_complete_transition_to_neighbor.call_deferred(direction)


## Completes a portal transition outside the Area2D body_entered physics callback.
func _complete_transition_to_neighbor(direction: String) -> void:
	if current_room_id == "" or not dungeon_graph.has("rooms"):
		transition_in_progress = false
		return
	var room_record: Dictionary = dungeon_graph["rooms"][current_room_id]
	var neighbors: Dictionary = room_record.get("neighbors", {})
	if not neighbors.has(direction):
		transition_in_progress = false
		return
	current_room_id = String(neighbors[direction])
	_load_current_room(direction)
	transition_in_progress = false


## Toggles the pause menu and global paused state for active runs.
func toggle_pause_menu() -> void:
	if inventory_menu.visible:
		inventory_menu.hide_inventory()
	if pause_menu.visible:
		_resume_from_pause()
	else:
		get_tree().paused = true
		pause_menu.show_pause()


## Toggles the inventory overlay and pauses gameplay while it is open.
func toggle_inventory_menu() -> void:
	if pause_menu.visible:
		pause_menu.hide_pause()
	if inventory_menu.visible:
		_resume_from_inventory()
	else:
		get_tree().paused = true
		inventory_menu.show_inventory()


## Triggers the temporary special/spell UI feedback for the Clockburst action.
func trigger_special_ui() -> void:
	special_indicator.trigger_special()


## Transfers run rewards into permanent progression, saves, and returns to the hub.
func complete_run(reason: String) -> void:
	_resume_from_pause()
	if run_currency > 0:
		SaveManager.add_permanent_currency(run_currency)
		SaveManager.save_game()
		run_currency = 0
		_update_currency_label()
	SignalBus.run_ended.emit(reason)
	SceneLoader.go_to_hub()


## Instantiates the scene assigned to the current graph room and connects room systems.
func _load_current_room(entry_direction: String) -> void:
	if active_room != null:
		active_room.queue_free()
	var room_record: Dictionary = dungeon_graph["rooms"][current_room_id]
	var packed_scene := load(String(room_record["scene_path"])) as PackedScene
	if packed_scene == null:
		push_error("DungeonRoot: room scene not found: %s" % room_record["scene_path"])
		return
	active_room = packed_scene.instantiate()
	active_room_container.add_child(active_room)
	if active_room.has_method("configure_room"):
		active_room.configure_room(room_record)
	if active_room.has_signal("exit_requested"):
		active_room.exit_requested.connect(transition_to_neighbor)
	_connect_enemies()
	_position_player_for_room(entry_direction)
	_update_room_labels(room_record)


## Connects enemies inside the active room to the player and run reward system.
func _connect_enemies() -> void:
	if active_room == null:
		return
	for enemy in active_room.get_tree().get_nodes_in_group("enemies"):
		if not active_room.is_ancestor_of(enemy):
			continue
		if enemy.has_method("set_target"):
			enemy.set_target(player)
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)


## Places the player at a safe point supplied by the active room prefab.
func _position_player_for_room(entry_direction: String) -> void:
	if active_room != null and active_room.has_method("get_player_spawn_position"):
		player.global_position = active_room.get_player_spawn_position(entry_direction)
	else:
		player.global_position = Vector2(640, 392)


## Updates labels that summarize the generated room currently being explored.
func _update_room_labels(room_record: Dictionary) -> void:
	var rooms: Dictionary = dungeon_graph.get("rooms", {})
	room_counter_label.text = "Room %d / %d" % [_visited_room_number(), rooms.size()]
	room_type_label.text = "Current: %s" % String(room_record.get("room_type", "unknown")).capitalize()


## Returns a stable display index for the active room id.
func _visited_room_number() -> int:
	return int(current_room_id.trim_prefix("room_")) + 1


## Updates the player's health display through the HUD scene.
func _on_player_health_changed(current_health: int, max_health: int) -> void:
	hud.set_health(current_health, max_health)


## Adds run currency and XP dropped by a dead enemy.
func _on_enemy_died(_enemy: Node, currency_value: int) -> void:
	run_currency += currency_value
	run_xp += currency_value * 2
	if run_xp >= xp_required:
		run_xp -= xp_required
		run_level += 1
		xp_required += 5
	_update_currency_label()
	_update_xp_label()


## Updates the run currency display earned during the generated run.
func _update_currency_label() -> void:
	hud.set_run_currency(run_currency)


## Updates the temporary XP display shown in the run HUD.
func _update_xp_label() -> void:
	hud.set_xp(run_xp, xp_required, run_level)


## Returns to the hub with collected rewards when the player dies.
func _on_player_died() -> void:
	complete_run("player_death")


## Resumes gameplay from the pause overlay.
func _resume_from_pause() -> void:
	pause_menu.hide_pause()
	get_tree().paused = false


## Resumes gameplay from the inventory overlay.
func _resume_from_inventory() -> void:
	inventory_menu.hide_inventory()
	get_tree().paused = false
