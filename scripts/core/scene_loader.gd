extends Node

## Loads main scenes into the GameRoot container.
## The autoload stays thin: it does not decide gameplay, it only performs transitions.

const START_MENU_SCENE := "res://scenes/menus/StartMenu.tscn"
const HUB_SCENE := "res://scenes/hub/Hub.tscn"
const DUNGEON_SCENE := "res://scenes/dungeon/DungeonRoot.tscn"

var _scene_container: Node = null
var _current_scene: Node = null
var _last_run_summary: Dictionary = {}


## Registers the container where game scenes will be instantiated.
func register_scene_container(container: Node) -> void:
	_scene_container = container


## Loads a scene by Godot path and cleanly replaces the active scene.
func change_scene(scene_path: String) -> void:
	if _scene_container == null:
		push_error("SceneLoader: no scene container registered.")
		return

	var packed_scene := load(scene_path) as PackedScene
	if packed_scene == null:
		push_error("SceneLoader: scene not found: %s" % scene_path)
		return

	if _current_scene != null:
		_current_scene.queue_free()

	_current_scene = packed_scene.instantiate()
	_scene_container.add_child(_current_scene)
	SignalBus.scene_changed.emit(scene_path)


## Shows the start menu and updates global state.
func go_to_start_menu() -> void:
	GameState.set_mode(GameState.Mode.START_MENU)
	change_scene(START_MENU_SCENE)


## Shows the central hub and updates global state.
func go_to_hub() -> void:
	GameState.set_mode(GameState.Mode.HUB)
	change_scene(HUB_SCENE)


## Shows the prototype dungeon scene and emits the run-start signal.
func start_run() -> void:
	GameState.set_mode(GameState.Mode.RUN)
	change_scene(DUNGEON_SCENE)
	SignalBus.run_started.emit()


## Stores the most recent run ending in a tiny transition-owned summary for the next hub scene.
func set_last_run_summary(reason: String, payout_gears: int) -> void:
	_last_run_summary = {
		"reason": reason,
		"payout_gears": max(0, payout_gears)
	}


## Returns a copy of the most recent run summary so hub UI can display flow feedback.
func get_last_run_summary() -> Dictionary:
	return _last_run_summary.duplicate()
