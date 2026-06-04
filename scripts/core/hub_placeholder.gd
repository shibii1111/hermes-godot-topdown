extends Node2D

## Foundation placeholder for the central hub.
## Later milestones will add the player, upgrade station, NPCs, and run portal.

@onready var start_run_button: Button = %StartRunButton
@onready var menu_button: Button = %MenuButton


## Connects temporary hub controls to verify transitions.
func _ready() -> void:
	start_run_button.pressed.connect(_on_start_run_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	start_run_button.grab_focus()


## Starts a prototype run through the SceneLoader.
func _on_start_run_pressed() -> void:
	SceneLoader.start_run()


## Returns to the start menu to validate basic navigation.
func _on_menu_pressed() -> void:
	SceneLoader.go_to_start_menu()
