extends Node
class_name PlayerDash

## Gère la fenêtre active et le cooldown du dash.
## Le déplacement reste calculé ailleurs pour garder les responsabilités séparées.

@export var dash_speed: float = 430.0
@export var dash_duration: float = 0.14
@export var dash_cooldown: float = 0.42

var _active_time_remaining: float = 0.0
var _cooldown_remaining: float = 0.0
var _dash_direction: Vector2 = Vector2.ZERO


## Met à jour timers et démarre un dash si le joueur le demande et que le cooldown est prêt.
func update_dash(delta: float, wants_dash: bool, facing_direction: Vector2) -> void:
	_active_time_remaining = maxf(0.0, _active_time_remaining - delta)
	_cooldown_remaining = maxf(0.0, _cooldown_remaining - delta)

	if wants_dash and _cooldown_remaining <= 0.0:
		_dash_direction = facing_direction.normalized()
		if _dash_direction == Vector2.ZERO:
			_dash_direction = Vector2.DOWN
		_active_time_remaining = dash_duration
		_cooldown_remaining = dash_cooldown


## Retourne la vitesse de dash quand il est actif, sinon zéro.
func get_dash_velocity() -> Vector2:
	if not is_dashing():
		return Vector2.ZERO
	return _dash_direction * dash_speed


## Indique si le dash est actuellement dans sa fenêtre active.
func is_dashing() -> bool:
	return _active_time_remaining > 0.0
