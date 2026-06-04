extends Control

## Menu de démarrage minimal mais fonctionnel.
## Il lance le hub, point d'entrée prévu de la boucle roguelite.

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton


## Connecte les boutons et place le focus pour le support manette/clavier.
func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	start_button.grab_focus()


## Lance le hub central depuis le menu de démarrage.
func _on_start_pressed() -> void:
	SceneLoader.go_to_hub()


## Quitte le prototype proprement.
func _on_quit_pressed() -> void:
	get_tree().quit()
