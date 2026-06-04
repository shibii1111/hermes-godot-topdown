extends Node2D

## Racine temporaire du donjon prototype.
## Elle existe pour valider le flow start menu -> hub -> run avant d'implémenter la génération procédurale.

@onready var hub_button: Button = %ReturnHubButton


## Connecte le bouton de retour hub utilisé pendant la fondation.
func _ready() -> void:
	hub_button.pressed.connect(_on_return_hub_pressed)
	hub_button.grab_focus()


## Termine la run prototype et renvoie le joueur au hub.
func _on_return_hub_pressed() -> void:
	SignalBus.run_ended.emit("manual_return")
	SceneLoader.go_to_hub()
