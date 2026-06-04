extends CanvasLayer
class_name HUD

## Displays run combat information without owning gameplay state.
## Gameplay systems push values into this view through explicit setter methods.

@onready var health_label: Label = %HealthLabel
@onready var run_currency_label: Label = %RunCurrencyLabel
@onready var xp_label: Label = %XPLabel


## Updates the player's current and maximum health text.
func set_health(current_health: int, max_health: int) -> void:
	health_label.text = "Health: %d / %d" % [current_health, max_health]


## Updates the run currency text for gears earned during the current run.
func set_run_currency(currency_value: int) -> void:
	run_currency_label.text = "Run gears: %d" % currency_value


## Updates the current run XP and level text.
func set_xp(current_xp: int, required_xp: int, level: int) -> void:
	xp_label.text = "Level %d - XP: %d / %d" % [level, current_xp, required_xp]
