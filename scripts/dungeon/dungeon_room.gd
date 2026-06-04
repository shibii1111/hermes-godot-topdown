extends Node2D
class_name DungeonRoom

## Runtime room prefab used by DungeonRoot.
## A room knows how to display available doors, but DungeonRoot owns graph traversal.

signal exit_requested(direction: String)

@export var room_title: String = "Clockwork Room"
@export var room_variant: String = "combat"

var room_id: String = ""
var available_neighbors: Dictionary = {}

@onready var title_label: Label = %RoomTitleLabel
@onready var type_label: Label = %RoomTypeLabel
@onready var enemy_spawns: Node2D = %EnemySpawns
@onready var north_button: Button = %NorthDoorButton
@onready var south_button: Button = %SouthDoorButton
@onready var east_button: Button = %EastDoorButton
@onready var west_button: Button = %WestDoorButton


## Connects door buttons once when the room prefab enters the scene tree.
func _ready() -> void:
	north_button.pressed.connect(func() -> void: exit_requested.emit("north"))
	south_button.pressed.connect(func() -> void: exit_requested.emit("south"))
	east_button.pressed.connect(func() -> void: exit_requested.emit("east"))
	west_button.pressed.connect(func() -> void: exit_requested.emit("west"))


## Applies graph metadata so this reusable room prefab can represent any generated room node.
func configure_room(room_record: Dictionary) -> void:
	room_id = String(room_record.get("id", ""))
	room_variant = String(room_record.get("room_type", room_variant))
	available_neighbors = room_record.get("neighbors", {})
	_update_labels()
	_update_door_buttons()


## Returns the safe player spawn point near the room center.
func get_player_spawn_position(_entry_direction: String = "") -> Vector2:
	return Vector2(640, 392)


## Updates visible text for the active room.
func _update_labels() -> void:
	if title_label == null or type_label == null:
		return
	title_label.text = "%s - %s" % [room_title, room_id]
	type_label.text = "Type: %s" % room_variant.capitalize()


## Enables only the cardinal exits present in the generated graph.
func _update_door_buttons() -> void:
	_set_door_state(north_button, "north")
	_set_door_state(south_button, "south")
	_set_door_state(east_button, "east")
	_set_door_state(west_button, "west")


## Shows and labels a door button when its direction has a graph neighbor.
func _set_door_state(button: Button, direction: String) -> void:
	var has_neighbor := available_neighbors.has(direction)
	button.visible = has_neighbor
	button.disabled = not has_neighbor
	button.text = direction.capitalize()
