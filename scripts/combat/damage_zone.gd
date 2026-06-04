extends Area2D
class_name DamageZone

const DamageDataScript := preload("res://scripts/combat/damage_data.gd")

## Test zone that periodically damages the player.
## It makes the health/damage system verifiable from Milestone 1 without waiting for enemies.

@export var damage_per_tick: int = 1
@export var tick_interval: float = 0.75

var _bodies_in_zone: Array[Node] = []
var _tick_remaining: float = 0.0


## Connects enter/exit signals and initializes the damage timer.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_tick_remaining = tick_interval


## Applies periodic damage to compatible bodies currently inside the area.
func _physics_process(delta: float) -> void:
	if _bodies_in_zone.is_empty():
		_tick_remaining = tick_interval
		return
	_tick_remaining -= delta
	if _tick_remaining > 0.0:
		return
	_tick_remaining = tick_interval
	for body in _bodies_in_zone:
		_apply_damage_to(body)


## Adds a body to the list and applies the first damage tick immediately.
func _on_body_entered(body: Node) -> void:
	if _bodies_in_zone.has(body):
		return
	_bodies_in_zone.append(body)
	_apply_damage_to(body)


## Removes a body that left the damage zone.
func _on_body_exited(body: Node) -> void:
	_bodies_in_zone.erase(body)


## Sends DamageData to the body if it exposes receive_damage().
func _apply_damage_to(body: Node) -> void:
	if not body.has_method("receive_damage"):
		return
	var damage_data: Resource = DamageDataScript.new()
	damage_data.amount = damage_per_tick
	body.receive_damage(damage_data.configure(self, Vector2.ZERO))
