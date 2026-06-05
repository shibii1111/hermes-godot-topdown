extends Area2D
class_name DungeonPortal

## Area-based room exit that activates when the player enters it.
## DungeonRoom decides whether this portal is currently enabled by graph neighbors.

signal portal_entered(direction: String)

@export_enum("north", "south", "east", "west") var direction: String = "north"

var enabled_for_room: bool = false
var visual: CanvasItem = null
var portal_highlight: Line2D = null
var direction_arrow: Polygon2D = null
var _readability_vfx_progress: float = 0.0


## Connects body detection once when the portal enters the scene tree.
func _ready() -> void:
	visual = get_node_or_null("Visual") as CanvasItem
	_ensure_readability_nodes()
	body_entered.connect(_on_body_entered)
	set_enabled_for_room(enabled_for_room)


## Enables or disables this portal based on the generated room graph.
func set_enabled_for_room(is_enabled: bool) -> void:
	enabled_for_room = is_enabled
	set_deferred("monitoring", is_enabled)
	set_deferred("monitorable", is_enabled)
	visible = is_enabled
	_readability_vfx_progress = 1.0 if is_enabled else 0.0
	if visual != null:
		visual.visible = is_enabled
	_update_readability_visuals()


## Returns normalized readability VFX progress for validations and future tuning.
func get_readability_vfx_progress() -> float:
	return _readability_vfx_progress


## Returns the current arrow rotation for direction validation/debugging.
func get_direction_arrow_rotation() -> float:
	if direction_arrow == null:
		return 0.0
	return direction_arrow.rotation


## Emits the portal direction only when the entering body is the player.
func _on_body_entered(body: Node) -> void:
	if not enabled_for_room:
		return
	if body == null:
		return
	if body.is_in_group("player") or body.name == "Player":
		portal_entered.emit(direction)


## Creates lightweight highlight/arrow children so every room prefab inherits readable exits.
func _ensure_readability_nodes() -> void:
	portal_highlight = get_node_or_null("PortalHighlight") as Line2D
	if portal_highlight == null:
		portal_highlight = Line2D.new()
		portal_highlight.name = "PortalHighlight"
		portal_highlight.width = 4.0
		portal_highlight.default_color = Color(0.95, 0.78, 0.35, 0.82)
		portal_highlight.closed = true
		add_child(portal_highlight)
	direction_arrow = get_node_or_null("DirectionArrow") as Polygon2D
	if direction_arrow == null:
		direction_arrow = Polygon2D.new()
		direction_arrow.name = "DirectionArrow"
		direction_arrow.color = Color(0.38, 0.95, 0.82, 0.9)
		direction_arrow.polygon = PackedVector2Array([Vector2(0, -8), Vector2(22, 0), Vector2(0, 8)])
		add_child(direction_arrow)
	_update_readability_shape()


## Updates the authored shape/orientation from the portal direction.
func _update_readability_shape() -> void:
	if portal_highlight == null or direction_arrow == null:
		return
	if direction in ["north", "south"]:
		portal_highlight.points = PackedVector2Array([Vector2(-74, -23), Vector2(74, -23), Vector2(74, 23), Vector2(-74, 23)])
	else:
		portal_highlight.points = PackedVector2Array([Vector2(-23, -74), Vector2(23, -74), Vector2(23, 74), Vector2(-23, 74)])
	match direction:
		"north":
			direction_arrow.rotation = -PI / 2.0
			direction_arrow.position = Vector2(0, 30)
		"south":
			direction_arrow.rotation = PI / 2.0
			direction_arrow.position = Vector2(0, -30)
		"east":
			direction_arrow.rotation = 0.0
			direction_arrow.position = Vector2(-30, 0)
		"west":
			direction_arrow.rotation = PI
			direction_arrow.position = Vector2(30, 0)


## Shows readability children only when the portal is a valid graph exit.
func _update_readability_visuals() -> void:
	if portal_highlight == null or direction_arrow == null:
		return
	_update_readability_shape()
	portal_highlight.visible = enabled_for_room
	direction_arrow.visible = enabled_for_room
	portal_highlight.default_color = Color(0.95, 0.78, 0.35, 0.82 if enabled_for_room else 0.0)
	direction_arrow.color = Color(0.38, 0.95, 0.82, 0.9 if enabled_for_room else 0.0)
