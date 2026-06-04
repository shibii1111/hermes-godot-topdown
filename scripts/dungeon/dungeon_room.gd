extends Node2D
class_name DungeonRoom

## Runtime room prefab used by DungeonRoot.
## A room displays available Area2D portals, but DungeonRoot owns graph traversal.

signal exit_requested(direction: String)

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


## Returns the safe player spawn point near the room center.
func get_player_spawn_position(_entry_direction: String = "") -> Vector2:
	return Vector2(960, 584)


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
	exit_requested.emit(direction)
