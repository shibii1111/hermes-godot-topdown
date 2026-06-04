extends Area2D
class_name Hitbox

const DamageDataScript := preload("res://scripts/combat/damage_data.gd")

## Zone qui inflige des dégâts à des hurtboxes.
## Elle garde une liste de cibles déjà touchées pendant une activation pour éviter les multi-hits accidentels.

@export var damage_amount: int = 1

var source: Node = null
var hit_direction: Vector2 = Vector2.DOWN
var _already_hit: Array[Node] = []


## Prépare les connexions Area2D et désactive la hitbox par défaut.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	monitoring = false


## Active la hitbox pour une attaque unique.
func activate(runtime_source: Node, direction: Vector2) -> void:
	source = runtime_source
	hit_direction = direction.normalized()
	_already_hit.clear()
	monitoring = true


## Désactive la hitbox et oublie les cibles précédentes.
func deactivate() -> void:
	monitoring = false
	_already_hit.clear()


## Applique les dégâts à une hurtbox compatible entrée dans la zone active.
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
