extends Control
class_name PauseMenu

## Pause overlay view for active runs.
## It exposes signals instead of changing scenes directly so the current room stays in control.

signal resume_requested()
signal return_hub_requested()

@onready var resume_button: Button = %ResumeButton
@onready var return_hub_button: Button = %ReturnHubButton


## Wires button signals and keeps the menu hidden until pause is requested.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_fit_to_viewport()
	get_viewport().size_changed.connect(_fit_to_viewport)
	resume_button.pressed.connect(resume_requested.emit)
	return_hub_button.pressed.connect(return_hub_requested.emit)
	hide_pause()


## Displays the pause menu and focuses Resume for controller navigation.
func show_pause() -> void:
	_fit_to_viewport()
	visible = true
	resume_button.grab_focus()


## Hides the pause menu when gameplay resumes.
func hide_pause() -> void:
	visible = false


## Keeps this overlay centered even when instanced below a Node2D gameplay root.
func _fit_to_viewport() -> void:
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 0.0
	anchor_bottom = 0.0
	position = Vector2.ZERO
	size = get_viewport_rect().size
