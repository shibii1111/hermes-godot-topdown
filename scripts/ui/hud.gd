extends CanvasLayer
class_name HUD

## Displays run combat information without owning gameplay state.
## Gameplay systems push values into this view through explicit setter methods.

@onready var health_label: Label = %HealthLabel
@onready var run_currency_label: Label = %RunCurrencyLabel
@onready var xp_label: Label = %XPLabel
@onready var stats_label: Label = %StatsLabel
@onready var feedback_label: Label = %FeedbackLabel

var _feedback_time_remaining: float = 0.0


## Counts down temporary feedback messages without owning gameplay state.
func _process(delta: float) -> void:
	if _feedback_time_remaining <= 0.0:
		return
	_feedback_time_remaining = max(0.0, _feedback_time_remaining - delta)
	if _feedback_time_remaining <= 0.0:
		feedback_label.visible = false


## Updates the player's current and maximum health text.
func set_health(current_health: int, max_health: int) -> void:
	health_label.text = "Health: %d / %d" % [current_health, max_health]


## Updates the run currency text for gears earned during the current run.
func set_run_currency(currency_value: int) -> void:
	run_currency_label.text = "Run gears: %d" % currency_value


## Updates the current run XP and level text.
func set_xp(current_xp: int, required_xp: int, level: int) -> void:
	xp_label.text = "Level %d - XP: %d / %d" % [level, current_xp, required_xp]


## Updates the current run stat bonuses and counters.
func set_run_stats(stats_text: String) -> void:
	stats_label.text = stats_text


## Shows a short, readable run feedback message for pickups and milestone moments.
func show_feedback(message: String, duration: float = 2.0) -> void:
	feedback_label.text = message
	feedback_label.visible = message != ""
	_feedback_time_remaining = max(0.0, duration)


## Returns the current feedback message for validations and UI consumers.
func get_feedback_text() -> String:
	return feedback_label.text
