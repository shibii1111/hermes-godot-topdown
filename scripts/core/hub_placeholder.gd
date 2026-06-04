extends Node2D

## Hub central placeholder de fondation.
## Les milestones suivants y ajouteront player, station d'upgrade, NPCs et portail de run.

@onready var start_run_button: Button = %StartRunButton
@onready var menu_button: Button = %MenuButton


## Connecte les contrôles temporaires du hub pour vérifier les transitions.
func _ready() -> void:
	start_run_button.pressed.connect(_on_start_run_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	start_run_button.grab_focus()


## Démarre une run prototype via le SceneLoader.
func _on_start_run_pressed() -> void:
	SceneLoader.start_run()


## Retourne au menu de démarrage pour valider la navigation de base.
func _on_menu_pressed() -> void:
	SceneLoader.go_to_start_menu()
