extends "res://scripts/combat/hitbox.gd"
class_name MeleeWeapon

## Hitbox spécialisée pour une arme melee placée devant le joueur.
## Elle reste active pendant une courte fenêtre puis se désactive automatiquement.

@export var reach: float = 34.0
@export var active_duration: float = 0.12

var _active_time_remaining: float = 0.0


## Met à jour la durée active de l'arme et coupe la hitbox à la fin du swing.
func _physics_process(delta: float) -> void:
	if _active_time_remaining <= 0.0:
		return
	_active_time_remaining = maxf(0.0, _active_time_remaining - delta)
	if _active_time_remaining == 0.0:
		deactivate()


## Place l'arme devant le joueur et active la hitbox de slash.
func swing(runtime_source: Node, direction: Vector2) -> void:
	var attack_direction := direction.normalized()
	if attack_direction == Vector2.ZERO:
		attack_direction = Vector2.DOWN
	position = attack_direction * reach
	rotation = attack_direction.angle()
	_active_time_remaining = active_duration
	activate(runtime_source, attack_direction)
