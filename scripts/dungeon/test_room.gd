extends Node2D

## Playable Milestone test room.
## It verifies movement, facing, dash, melee attack, health/damage, enemies, and the run UI layer.

@onready var player: Node = %Player
@onready var hud: Node = %HUD
@onready var pause_menu: Node = %PauseMenu
@onready var inventory_menu: Node = %InventoryMenu
@onready var special_indicator: Node = %SpecialIndicator
@onready var return_hub_button: Button = %ReturnHubButton

var run_currency: int = 0
var run_xp: int = 0
var run_level: int = 1
var xp_required: int = 10


## Connects the player, enemies, and temporary test UI controls.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	pause_menu.resume_requested.connect(_resume_from_pause)
	pause_menu.return_hub_requested.connect(_on_return_hub_pressed)
	inventory_menu.close_requested.connect(_resume_from_inventory)
	return_hub_button.pressed.connect(_on_return_hub_pressed)
	_connect_enemies()
	_on_player_health_changed(player.health_component.current_health, player.health_component.max_health)
	_update_currency_label()
	_update_xp_label()


## Handles run UI shortcuts while keeping gameplay input in player-specific scripts.
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


## Updates the player's health display through the HUD scene.
func _on_player_health_changed(current_health: int, max_health: int) -> void:
	hud.set_health(current_health, max_health)


## Connects enemies present in the room to the player and drop system.
func _connect_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_method("set_target"):
			enemy.set_target(player)
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)


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


## Updates the run currency display earned during the test run.
func _update_currency_label() -> void:
	hud.set_run_currency(run_currency)


## Updates the temporary XP display shown in the run HUD.
func _update_xp_label() -> void:
	hud.set_xp(run_xp, xp_required, run_level)


## Simulates the minimal roguelite loop: return to the hub on death.
func _on_player_died() -> void:
	complete_run("player_death")


## Allows leaving the test room manually without dying.
func _on_return_hub_pressed() -> void:
	complete_run("manual_return")


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


## Resumes gameplay from the pause overlay.
func _resume_from_pause() -> void:
	pause_menu.hide_pause()
	get_tree().paused = false


## Resumes gameplay from the inventory overlay.
func _resume_from_inventory() -> void:
	inventory_menu.hide_inventory()
	get_tree().paused = false
