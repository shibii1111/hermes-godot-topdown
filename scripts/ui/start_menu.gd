extends Control

## Minimal but functional start menu.
## It launches the hub, the planned entry point for the roguelite loop.

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton


## Connects buttons and sets focus for controller/keyboard support.
func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	start_button.grab_focus()


## Launches the central hub from the start menu.
func _on_start_pressed() -> void:
	SceneLoader.go_to_hub()


## Quits the prototype cleanly.
func _on_quit_pressed() -> void:
	get_tree().quit()
