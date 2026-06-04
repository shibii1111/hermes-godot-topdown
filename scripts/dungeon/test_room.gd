extends Node2D

## Playable Milestone test room.
## It verifies movement, facing, dash, melee attack, and health/damage before full dungeon work.

@onready var player: Node = %Player
@onready var health_label: Label = %HealthLabel
@onready var currency_label: Label = %CurrencyLabel
@onready var return_hub_button: Button = %ReturnHubButton

var run_currency: int = 0


## Connects the player and temporary test UI controls.
func _ready() -> void:
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	return_hub_button.pressed.connect(_on_return_hub_pressed)
	_connect_enemies()
	_on_player_health_changed(player.health_component.current_health, player.health_component.max_health)
	_update_currency_label()


## Updates the player's health display.
func _on_player_health_changed(current_health: int, max_health: int) -> void:
	health_label.text = "Health: %d / %d" % [current_health, max_health]


## Connects enemies present in the room to the player and drop system.
func _connect_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_method("set_target"):
			enemy.set_target(player)
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)


## Adds run currency dropped by a dead enemy.
func _on_enemy_died(_enemy: Node, currency_value: int) -> void:
	run_currency += currency_value
	_update_currency_label()


## Updates the run currency display earned during the test run.
func _update_currency_label() -> void:
	currency_label.text = "Run gears: %d" % run_currency


## Simulates the minimal roguelite loop: return to the hub on death.
func _on_player_died() -> void:
	SignalBus.run_ended.emit("player_death")
	SceneLoader.go_to_hub()


## Allows leaving the test room manually without dying.
func _on_return_hub_pressed() -> void:
	SignalBus.run_ended.emit("manual_return")
	SceneLoader.go_to_hub()
