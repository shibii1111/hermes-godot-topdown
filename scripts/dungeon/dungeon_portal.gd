extends Area2D
class_name DungeonPortal

## Area-based room exit that activates when the player enters it.
## DungeonRoom decides whether this portal is currently enabled by graph neighbors.

signal portal_entered(direction: String)

@export_enum("north", "south", "east", "west") var direction: String = "north"

var enabled_for_room: bool = false
var visual: Polygon2D = null


## Connects body detection once when the portal enters the scene tree.
func _ready() -> void:
	visual = get_node_or_null("Visual") as Polygon2D
	body_entered.connect(_on_body_entered)
	set_enabled_for_room(enabled_for_room)


## Enables or disables this portal based on the generated room graph.
func set_enabled_for_room(is_enabled: bool) -> void:
	enabled_for_room = is_enabled
	set_deferred("monitoring", is_enabled)
	set_deferred("monitorable", is_enabled)
	visible = is_enabled
	if visual != null:
		visual.visible = is_enabled


## Emits the portal direction only when the entering body is the player.
func _on_body_entered(body: Node) -> void:
	if not enabled_for_room:
		return
	if body == null:
		return
	if body.is_in_group("player") or body.name == "Player":
		portal_entered.emit(direction)
