extends Node2D
class_name DungeonRoot

## Runs a generated branching dungeon for the current roguelite run.
## It owns graph traversal, active room swapping, player placement, and run reward payout.

const DungeonGeneratorScript := preload("res://scripts/dungeon/dungeon_generator.gd")
const RunProgressionScript := preload("res://scripts/progression/run_progression.gd")
const EquipmentItemScript := preload("res://scripts/equipment/equipment_item.gd")
const GearPickupScene := preload("res://scenes/items/GearPickup.tscn")
const FIRST_HAUL_QUEST := "collect_3_gears"

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
var progression = RunProgressionScript.new()
var transition_in_progress: bool = false
var portal_transition_blocked_until_msec: int = 0


## Starts a generated run and wires shared run UI.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	progression.changed.connect(_on_progression_changed)
	progression.leveled_up.connect(_on_run_leveled_up)
	progression.equip_item(EquipmentItemScript.create_clockwork_blade())
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	pause_menu.resume_requested.connect(_resume_from_pause)
	pause_menu.return_hub_requested.connect(func() -> void: complete_run("manual_return"))
	inventory_menu.close_requested.connect(_resume_from_inventory)
	return_hub_button.pressed.connect(func() -> void: complete_run("manual_return"))
	_on_player_health_changed(player.health_component.current_health, player.health_component.max_health)
	_apply_progression_damage_bonus()
	_update_progression_labels()
	_update_inventory_equipment()
	_bind_special_indicator()
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
## When a room id is supplied, stale portal signals from unloaded rooms are ignored.
func transition_to_neighbor(direction: String, source_room_id: String = "") -> void:
	if Time.get_ticks_msec() < portal_transition_blocked_until_msec:
		return
	if source_room_id != "" and source_room_id != current_room_id:
		return
	if transition_in_progress:
		return
	transition_in_progress = true
	_complete_transition_to_neighbor.call_deferred(direction, current_room_id)


## Completes a portal transition outside the Area2D body_entered physics callback.
func _complete_transition_to_neighbor(direction: String, source_room_id: String = "") -> void:
	if source_room_id != "" and source_room_id != current_room_id:
		transition_in_progress = false
		return
	if current_room_id == "" or not dungeon_graph.has("rooms"):
		transition_in_progress = false
		return
	var room_record: Dictionary = dungeon_graph["rooms"][current_room_id]
	var neighbors: Dictionary = room_record.get("neighbors", {})
	if not neighbors.has(direction):
		transition_in_progress = false
		return
	portal_transition_blocked_until_msec = Time.get_ticks_msec() + 350
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
	if player.has_method("cast_clockburst"):
		player.cast_clockburst()


## Transfers run rewards into permanent progression, updates quest progress, saves, and returns to the hub.
func complete_run(reason: String) -> void:
	_resume_from_pause()
	if progression.run_currency > 0:
		SaveManager.add_quest_progress(FIRST_HAUL_QUEST, progression.run_currency)
		SaveManager.add_permanent_currency(progression.run_currency)
		SaveManager.save_game()
		progression.run_currency = 0
		_update_progression_labels()
	SignalBus.run_ended.emit(reason)
	SceneLoader.go_to_hub()


## Instantiates the scene assigned to the current graph room and connects room systems.
func _load_current_room(entry_direction: String) -> void:
	_unload_active_room()
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


## Removes the previous room from the scene tree before loading the next one.
## This prevents queued-for-deletion portal Area2Ds from firing stale transitions after teleporting the player.
func _unload_active_room() -> void:
	if active_room == null:
		return
	if active_room.get_parent() != null:
		active_room.get_parent().remove_child(active_room)
	active_room.queue_free()
	active_room = null


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


## Grants enemy XP immediately and drops run currency as physical loot.
func _on_enemy_died(_enemy: Node, currency_value: int, xp_value: int) -> void:
	progression.grant_enemy_reward(0, xp_value)
	_spawn_currency_pickup.call_deferred(_enemy, currency_value)


## Spawns a physical gear pickup for enemy currency so loot is collected in-world.
func _spawn_currency_pickup(enemy: Node, currency_value: int) -> void:
	if currency_value <= 0 or active_room == null:
		return
	var pickup: Area2D = GearPickupScene.instantiate()
	pickup.currency_value = currency_value
	active_room.add_child(pickup)
	if enemy is Node2D:
		pickup.global_position = enemy.global_position
	pickup.collected.connect(_on_currency_pickup_collected)


## Converts a collected loot pickup into run currency progression and readable HUD feedback.
func _on_currency_pickup_collected(currency_value: int) -> void:
	progression.grant_run_currency(currency_value)
	if hud.has_method("show_feedback"):
		hud.show_feedback("Collected +%d run gears" % currency_value)


## Applies run-level stat bonuses when the XP curve grants a level.
func _on_run_leveled_up(_new_level: int, _damage_bonus: int) -> void:
	_apply_progression_damage_bonus()


## Refreshes HUD labels when run-only progression changes.
func _on_progression_changed(_progression: RefCounted) -> void:
	_apply_progression_damage_bonus()
	_update_progression_labels()
	_update_inventory_equipment()


## Updates the run currency, XP, level, and stat displays.
func _update_progression_labels() -> void:
	hud.set_run_currency(progression.run_currency)
	hud.set_xp(progression.current_xp, progression.xp_to_next_level, progression.level)
	hud.set_run_stats(progression.get_stats_text())


## Applies the combined equipment and level damage bonus to the player weapon.
func _apply_progression_damage_bonus() -> void:
	if player.has_method("set_run_damage_bonus"):
		player.set_run_damage_bonus(progression.get_total_damage_bonus())


## Keeps the inventory overlay bound to the current equipment loadout.
func _update_inventory_equipment() -> void:
	if inventory_menu.has_method("set_equipment_summary"):
		inventory_menu.set_equipment_summary(progression.get_equipment_summary_text())


## Binds the special HUD element to the player's real Clockburst ability.
func _bind_special_indicator() -> void:
	if player.has_method("get_clockburst_ability") and special_indicator.has_method("bind_clockburst"):
		special_indicator.bind_clockburst(player.get_clockburst_ability())


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
