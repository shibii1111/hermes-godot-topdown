extends Node

## Charge les scènes principales dans le conteneur du GameRoot.
## L'autoload reste mince: il ne décide pas du gameplay, il effectue seulement les transitions.

const START_MENU_SCENE := "res://scenes/menus/StartMenu.tscn"
const HUB_SCENE := "res://scenes/hub/Hub.tscn"
const DUNGEON_SCENE := "res://scenes/dungeon/TestRoom.tscn"

var _scene_container: Node = null
var _current_scene: Node = null


## Enregistre le conteneur où les scènes de jeu seront instanciées.
func register_scene_container(container: Node) -> void:
	_scene_container = container


## Charge une scène par chemin Godot et remplace proprement la scène active.
func change_scene(scene_path: String) -> void:
	if _scene_container == null:
		push_error("SceneLoader: aucun conteneur de scène enregistré.")
		return

	var packed_scene := load(scene_path) as PackedScene
	if packed_scene == null:
		push_error("SceneLoader: scène introuvable: %s" % scene_path)
		return

	if _current_scene != null:
		_current_scene.queue_free()

	_current_scene = packed_scene.instantiate()
	_scene_container.add_child(_current_scene)
	SignalBus.scene_changed.emit(scene_path)


## Affiche le menu de démarrage et met à jour l'état global.
func go_to_start_menu() -> void:
	GameState.set_mode(GameState.Mode.START_MENU)
	change_scene(START_MENU_SCENE)


## Affiche le hub central et met à jour l'état global.
func go_to_hub() -> void:
	GameState.set_mode(GameState.Mode.HUB)
	change_scene(HUB_SCENE)


## Affiche la scène de donjon prototype et déclenche le signal de run.
func start_run() -> void:
	GameState.set_mode(GameState.Mode.RUN)
	change_scene(DUNGEON_SCENE)
	SignalBus.run_started.emit()
