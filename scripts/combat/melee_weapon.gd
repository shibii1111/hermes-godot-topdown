extends "res://scripts/combat/hitbox.gd"
class_name MeleeWeapon

## Specialized hitbox for a melee weapon placed in front of the player.
## It stays active for a short window, then disables itself automatically.

@export var reach: float = 34.0
@export var active_duration: float = 0.12

var _active_time_remaining: float = 0.0


## Initializes the inherited hitbox and hides the weapon until a swing starts.
func _ready() -> void:
	super._ready()
	visible = false


## Updates the weapon's active duration and disables the hitbox at the end of the swing.
func _physics_process(delta: float) -> void:
	if _active_time_remaining <= 0.0:
		return
	_active_time_remaining = maxf(0.0, _active_time_remaining - delta)
	if _active_time_remaining == 0.0:
		deactivate()


## Places the weapon in front of the player and activates the slash hitbox.
func swing(runtime_source: Node, direction: Vector2) -> void:
	var attack_direction := direction.normalized()
	if attack_direction == Vector2.ZERO:
		attack_direction = Vector2.DOWN
	position = attack_direction * reach
	rotation = attack_direction.angle()
	_active_time_remaining = active_duration
	visible = true
	activate(runtime_source, attack_direction)


## Disables damage and hides the temporary slash visual.
func deactivate() -> void:
	super.deactivate()
	visible = false
