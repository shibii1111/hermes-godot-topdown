extends Node

## Racine persistante du jeu.
## Elle fournit un conteneur stable au SceneLoader pour remplacer menu, hub et donjon.

@onready var scene_container: Node = $SceneContainer


## Connecte la racine au SceneLoader puis affiche le start menu initial.
func _ready() -> void:
	SceneLoader.register_scene_container(scene_container)
	SceneLoader.go_to_start_menu()
