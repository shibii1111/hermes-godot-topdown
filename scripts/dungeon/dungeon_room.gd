extends Node2D
class_name DungeonRoom

## Runtime room prefab used by DungeonRoot.
## A room displays available Area2D portals, but DungeonRoot owns graph traversal.

signal exit_requested(direction: String, source_room_id: String)

const ROOM_CENTER := Vector2(960, 584)
const PORTAL_SPAWN_OFFSET := 176.0
const OPPOSITE_DIRECTIONS := {
	"north": "south",
	"south": "north",
	"east": "west",
	"west": "east"
}
const PORTAL_INWARD_OFFSETS := {
	"north": Vector2(0, PORTAL_SPAWN_OFFSET),
	"south": Vector2(0, -PORTAL_SPAWN_OFFSET),
	"east": Vector2(-PORTAL_SPAWN_OFFSET, 0),
	"west": Vector2(PORTAL_SPAWN_OFFSET, 0)
}

@export var room_title: String = "Clockwork Room"
@export var room_variant: String = "combat"

var room_id: String = ""
var available_neighbors: Dictionary = {}

@onready var title_label: Label = %RoomTitleLabel
@onready var type_label: Label = %RoomTypeLabel
@onready var enemy_spawns: Node2D = %EnemySpawns
@onready var north_portal: Area2D = %NorthPortal
@onready var south_portal: Area2D = %SouthPortal
@onready var east_portal: Area2D = %EastPortal
@onready var west_portal: Area2D = %WestPortal


## Connects portal Area2D signals once when the room prefab enters the scene tree.
func _ready() -> void:
	north_portal.portal_entered.connect(_on_portal_entered)
	south_portal.portal_entered.connect(_on_portal_entered)
	east_portal.portal_entered.connect(_on_portal_entered)
	west_portal.portal_entered.connect(_on_portal_entered)
	_update_portals()


## Applies graph metadata so this reusable room prefab can represent any generated room node.
func configure_room(room_record: Dictionary) -> void:
	room_id = String(room_record.get("id", ""))
	room_variant = String(room_record.get("room_type", room_variant))
	available_neighbors = room_record.get("neighbors", {})
	_update_labels()
	_update_portals()


## Returns a safe player spawn point for the active room.
## Fresh runs use the center, while portal entries spawn just inside the opposite portal.
func get_player_spawn_position(entry_direction: String = "") -> Vector2:
	if not OPPOSITE_DIRECTIONS.has(entry_direction):
		return ROOM_CENTER
	var opposite_direction := String(OPPOSITE_DIRECTIONS[entry_direction])
	var portal := _portal_for_direction(opposite_direction)
	if portal == null:
		return ROOM_CENTER
	return portal.global_position + PORTAL_INWARD_OFFSETS[opposite_direction]


## Finds the portal node that matches a cardinal direction.
func _portal_for_direction(portal_direction: String) -> Node2D:
	match portal_direction:
		"north":
			return north_portal as Node2D
		"south":
			return south_portal as Node2D
		"east":
			return east_portal as Node2D
		"west":
			return west_portal as Node2D
		_:
			return null


## Updates visible text for the active room.
func _update_labels() -> void:
	if title_label == null or type_label == null:
		return
	title_label.text = "%s - %s" % [room_title, room_id]
	type_label.text = "Type: %s" % room_variant.capitalize()


## Enables only the cardinal portals present in the generated graph.
func _update_portals() -> void:
	_set_portal_state(north_portal, "north")
	_set_portal_state(south_portal, "south")
	_set_portal_state(east_portal, "east")
	_set_portal_state(west_portal, "west")


## Shows and activates a portal when its direction has a graph neighbor.
func _set_portal_state(portal: Area2D, direction: String) -> void:
	if portal == null:
		return
	portal.set("direction", direction)
	if portal.has_method("set_enabled_for_room"):
		portal.set_enabled_for_room(available_neighbors.has(direction))


## Requests a graph transition after the player enters an enabled portal Area2D.
func _on_portal_entered(direction: String) -> void:
	exit_requested.emit(direction, room_id)
