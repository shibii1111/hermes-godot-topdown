extends Node
class_name PlayerCombat

## Orchestrates the player's melee attack without reading inputs directly.
## Attack direction is provided by PlayerFacing to stay faithful to the non-twin-stick design.

@export var attack_cooldown: float = 0.28

@onready var melee_weapon: Node = %MeleeWeapon

var _cooldown_remaining: float = 0.0
var _facing_direction: Vector2 = Vector2.DOWN


## Decreases the attack cooldown on each physics frame.
func update_combat(delta: float) -> void:
	_cooldown_remaining = maxf(0.0, _cooldown_remaining - delta)


## Stores the direction the next attack will use.
func update_weapon_direction(direction: Vector2) -> void:
	if direction.length_squared() < 0.01:
		return
	_facing_direction = direction.normalized()
	melee_weapon.position = _facing_direction * melee_weapon.reach
	melee_weapon.rotation = _facing_direction.angle()


## Starts a melee attack if the cooldown allows it.
func try_attack(source: Node) -> bool:
	if _cooldown_remaining > 0.0:
		return false
	_cooldown_remaining = attack_cooldown
	melee_weapon.swing(source, _facing_direction)
	return true
