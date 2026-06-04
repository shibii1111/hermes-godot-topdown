extends Control
class_name SpecialIndicator

## Minimal special/spell UI for Milestone 3.
## The real ability system will connect to this later; for now it proves input and feedback paths.

@onready var status_label: Label = %StatusLabel
@onready var cooldown_bar: ProgressBar = %CooldownBar

var cooldown_time: float = 0.0


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


## Advances the temporary cooldown display while the scene is active.
func _process(delta: float) -> void:
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
