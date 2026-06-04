extends Node

## Persistent game root.
## It provides SceneLoader with a stable container for replacing menu, hub, and dungeon scenes.

@onready var scene_container: Node = $SceneContainer


## Connects the root to SceneLoader, then shows the initial start menu.
func _ready() -> void:
	SceneLoader.register_scene_container(scene_container)
	SceneLoader.go_to_start_menu()
