extends RefCounted
class_name DungeonGenerator

## Builds a small Binding-of-Isaac-inspired branching room graph.
## The topology is intentionally reliable for the prototype while room prefab assignment stays deterministic by seed.

const ROOM_SCENE_PATHS := [
	"res://scenes/dungeon/rooms/Room01.tscn",
	"res://scenes/dungeon/rooms/Room02.tscn",
	"res://scenes/dungeon/rooms/Room03.tscn",
	"res://scenes/dungeon/rooms/Room04.tscn",
	"res://scenes/dungeon/rooms/Room05.tscn",
	"res://scenes/dungeon/rooms/Room06.tscn",
	"res://scenes/dungeon/rooms/Room07.tscn",
	"res://scenes/dungeon/rooms/Room08.tscn",
	"res://scenes/dungeon/rooms/Room09.tscn",
	"res://scenes/dungeon/rooms/Room10.tscn"
]

const OPPOSITE_DIRECTIONS := {
	"north": "south",
	"south": "north",
	"east": "west",
	"west": "east"
}


## Generates a 10-room connected graph with a main path and optional branches.
func generate(seed_value: int = 0) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var layout := _build_branching_layout()
	var shuffled_paths := ROOM_SCENE_PATHS.duplicate()
	_shuffle_paths(shuffled_paths, rng)
	var rooms := {}
	for index in range(layout.size()):
		var layout_room: Dictionary = layout[index]
		var room_id := "room_%02d" % index
		rooms[room_id] = {
			"id": room_id,
			"grid_position": layout_room["grid_position"],
			"room_type": layout_room["room_type"],
			"scene_path": shuffled_paths[index],
			"neighbors": {}
		}
	_connect_by_positions(rooms)
	return {
		"rooms": rooms,
		"start_room_id": "room_00",
		"exit_room_id": "room_05",
		"main_path": ["room_00", "room_01", "room_02", "room_03", "room_04", "room_05"]
	}


## Returns the fixed reliable prototype topology used by the generator.
func _build_branching_layout() -> Array[Dictionary]:
	return [
		{"grid_position": Vector2i(0, 0), "room_type": "start"},
		{"grid_position": Vector2i(1, 0), "room_type": "combat"},
		{"grid_position": Vector2i(2, 0), "room_type": "junction"},
		{"grid_position": Vector2i(3, 0), "room_type": "combat"},
		{"grid_position": Vector2i(4, 0), "room_type": "elite"},
		{"grid_position": Vector2i(5, 0), "room_type": "exit"},
		{"grid_position": Vector2i(2, -1), "room_type": "combat"},
		{"grid_position": Vector2i(2, -2), "room_type": "reward"},
		{"grid_position": Vector2i(2, 1), "room_type": "combat"},
		{"grid_position": Vector2i(3, 1), "room_type": "forge"}
	]


## Deterministically shuffles room prefab assignment while preserving graph shape.
func _shuffle_paths(paths: Array, rng: RandomNumberGenerator) -> void:
	for index in range(paths.size() - 1, 0, -1):
		var swap_index := rng.randi_range(0, index)
		var current_path = paths[index]
		paths[index] = paths[swap_index]
		paths[swap_index] = current_path


## Creates bidirectional cardinal links between adjacent grid rooms.
func _connect_by_positions(rooms: Dictionary) -> void:
	for room_id in rooms.keys():
		for other_id in rooms.keys():
			if room_id == other_id:
				continue
			var delta: Vector2i = rooms[other_id]["grid_position"] - rooms[room_id]["grid_position"]
			var direction := _direction_from_delta(delta)
			if direction != "":
				rooms[room_id]["neighbors"][direction] = other_id


## Converts an adjacent grid delta into a cardinal direction name.
func _direction_from_delta(delta: Vector2i) -> String:
	match delta:
		Vector2i(0, -1):
			return "north"
		Vector2i(0, 1):
			return "south"
		Vector2i(1, 0):
			return "east"
		Vector2i(-1, 0):
			return "west"
		_:
			return ""
