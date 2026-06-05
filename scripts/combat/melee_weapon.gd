extends "res://scripts/combat/hitbox.gd"
class_name MeleeWeapon

## Specialized hitbox for a melee weapon placed in front of the player.
## It stays active for a short window, then disables itself automatically.

@export var reach: float = 34.0
@export var active_duration: float = 0.12

@onready var attack_arc: Line2D = %AttackArc

var _active_time_remaining: float = 0.0
var _slash_vfx_progress: float = 0.0


## Initializes the inherited hitbox and hides the weapon until a swing starts.
func _ready() -> void:
	super._ready()
	visible = false
	attack_arc.visible = false


## Updates the weapon's active duration and disables the hitbox at the end of the swing.
func _physics_process(delta: float) -> void:
	if _active_time_remaining <= 0.0:
		return
	_active_time_remaining = maxf(0.0, _active_time_remaining - delta)
	_slash_vfx_progress = _active_time_remaining / active_duration
	attack_arc.default_color = Color(1.0, 0.82, 0.35, 0.85 * _slash_vfx_progress)
	if _active_time_remaining == 0.0:
		deactivate()


## Returns normalized slash VFX progress for validation and tuning.
func get_slash_vfx_progress() -> float:
	return _slash_vfx_progress


## Places the weapon in front of the player and activates the slash hitbox.
func swing(runtime_source: Node, direction: Vector2) -> void:
	var attack_direction := direction.normalized()
	if attack_direction == Vector2.ZERO:
		attack_direction = Vector2.DOWN
	position = attack_direction * reach
	rotation = attack_direction.angle()
	_active_time_remaining = active_duration
	_slash_vfx_progress = 1.0
	visible = true
	attack_arc.visible = true
	attack_arc.default_color = Color(1.0, 0.82, 0.35, 0.85)
	attack_arc.width = 4.0
	activate(runtime_source, attack_direction)


## Disables damage and hides the temporary slash visual.
func deactivate() -> void:
	super.deactivate()
	visible = false
	attack_arc.visible = false
	_slash_vfx_progress = 0.0
