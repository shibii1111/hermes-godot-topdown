extends Area2D
class_name Hitbox

const DamageDataScript := preload("res://scripts/combat/damage_data.gd")

## Area that deals damage to hurtboxes.
## It tracks targets already hit during one activation to avoid accidental multi-hits.

@export var damage_amount: int = 1

var source: Node = null
var hit_direction: Vector2 = Vector2.DOWN
var _already_hit: Array[Node] = []


## Prepares Area2D connections and disables the hitbox by default.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	monitoring = false


## Activates the hitbox for a single attack.
func activate(runtime_source: Node, direction: Vector2) -> void:
	source = runtime_source
	hit_direction = direction.normalized()
	_already_hit.clear()
	monitoring = true


## Disables the hitbox and clears previously hit targets.
func deactivate() -> void:
	monitoring = false
	_already_hit.clear()


## Applies damage to a compatible hurtbox entering the active area.
func _on_area_entered(area: Area2D) -> void:
	if not monitoring or _already_hit.has(area):
		return
	if source != null and source.is_ancestor_of(area):
		return
	if not area.has_method("receive_damage"):
		return
	_already_hit.append(area)
	var damage_data: Resource = DamageDataScript.new()
	damage_data.amount = damage_amount
	area.receive_damage(damage_data.configure(source, hit_direction))
