extends Node
class_name PlayerCombat

## Orchestre l'attaque melee du joueur sans lire les inputs directement.
## La direction d'attaque est fournie par PlayerFacing pour rester fidèle au design non twin-stick.

@export var attack_cooldown: float = 0.28

@onready var melee_weapon: Node = %MeleeWeapon

var _cooldown_remaining: float = 0.0
var _facing_direction: Vector2 = Vector2.DOWN


## Diminue le cooldown d'attaque à chaque frame physique.
func update_combat(delta: float) -> void:
	_cooldown_remaining = maxf(0.0, _cooldown_remaining - delta)


## Stocke la direction que la prochaine attaque utilisera.
func update_weapon_direction(direction: Vector2) -> void:
	if direction.length_squared() < 0.01:
		return
	_facing_direction = direction.normalized()
	melee_weapon.position = _facing_direction * melee_weapon.reach
	melee_weapon.rotation = _facing_direction.angle()


## Lance une attaque melee si le cooldown le permet.
func try_attack(source: Node) -> bool:
	if _cooldown_remaining > 0.0:
		return false
	_cooldown_remaining = attack_cooldown
	melee_weapon.swing(source, _facing_direction)
	return true
