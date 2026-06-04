extends Node2D

## Temporary root for the prototype dungeon.
## It exists to validate the start menu -> hub -> run flow before procedural generation is implemented.

@onready var hub_button: Button = %ReturnHubButton


## Connects the return-to-hub button used during the foundation phase.
func _ready() -> void:
	hub_button.pressed.connect(_on_return_hub_pressed)
	hub_button.grab_focus()


## Ends the prototype run and sends the player back to the hub.
func _on_return_hub_pressed() -> void:
	SignalBus.run_ended.emit("manual_return")
	SceneLoader.go_to_hub()
