extends Control
class_name SpecialIndicator

## Displays the real Clockburst spell state pushed by the ability cooldown signal.

@onready var status_label: Label = %StatusLabel
@onready var cooldown_bar: ProgressBar = %CooldownBar

var cooldown_time: float = 0.0
var bound_clockburst: Node = null


## Initializes the indicator in a ready state.
func _ready() -> void:
	_fit_to_viewport()
	get_viewport().size_changed.connect(_fit_to_viewport)
	set_ready()


## Shows immediate feedback when the special input is triggered.
func trigger_special() -> void:
	cooldown_time = 1.0
	status_label.text = "Clockburst readying..."
	cooldown_bar.value = 0.0


## Connects the indicator to the real Clockburst ability node.
func bind_clockburst(clockburst: Node) -> void:
	bound_clockburst = clockburst
	if bound_clockburst.has_signal("cooldown_changed"):
		bound_clockburst.cooldown_changed.connect(show_cooldown)
	if bound_clockburst.has_method("is_ready") and bound_clockburst.is_ready():
		set_ready()


## Updates the status label and progress bar from ability cooldown data.
func show_cooldown(remaining: float, duration: float) -> void:
	if remaining <= 0.0:
		set_ready()
		return
	status_label.text = "Clockburst cooling down"
	var safe_duration := maxf(duration, 0.01)
	cooldown_bar.value = 100.0 * (1.0 - (remaining / safe_duration))
	cooldown_time = remaining


## Returns the visible status text for headless validation.
func get_status_text() -> String:
	return status_label.text


## Advances the temporary cooldown display while the scene is active.
func _process(delta: float) -> void:
	if bound_clockburst != null:
		return
	if cooldown_time <= 0.0:
		return
	cooldown_time = maxf(cooldown_time - delta, 0.0)
	cooldown_bar.value = 100.0 * (1.0 - cooldown_time)
	if cooldown_time == 0.0:
		set_ready()


## Resets the special indicator to its ready state.
func set_ready() -> void:
	status_label.text = "Clockburst ready"
	cooldown_bar.value = 100.0


## Keeps the bottom-right anchor relative to the viewport below Node2D gameplay roots.
func _fit_to_viewport() -> void:
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 0.0
	anchor_bottom = 0.0
	position = Vector2.ZERO
	size = get_viewport_rect().size
