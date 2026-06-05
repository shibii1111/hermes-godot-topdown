extends "res://scripts/combat/hitbox.gd"
class_name ClockburstAbility

## Radial starter spell that bursts clockwork energy around the player.
## It reuses Hitbox damage routing but owns its cooldown and short active window.

signal cast_started()
signal cooldown_changed(remaining: float, duration: float)

@export var cooldown_duration: float = 3.0
@export var active_duration: float = 0.18

var _cooldown_remaining: float = 0.0
var _active_time_remaining: float = 0.0


## Initializes the radial hitbox in an inactive, ready state.
func _ready() -> void:
	super._ready()
	visible = false
	cooldown_changed.emit(_cooldown_remaining, cooldown_duration)


## Advances active hit timing and cooldown state each physics frame.
func _physics_process(delta: float) -> void:
	if _active_time_remaining > 0.0:
		_active_time_remaining = maxf(0.0, _active_time_remaining - delta)
		if _active_time_remaining == 0.0:
			deactivate()
	update_cooldown(delta)


## Returns true when the spell can currently be cast.
func is_ready() -> bool:
	return _cooldown_remaining <= 0.0


## Attempts to cast Clockburst from the supplied source node.
func cast(runtime_source: Node, direction: Vector2 = Vector2.DOWN) -> bool:
	if not is_ready():
		return false
	_cooldown_remaining = cooldown_duration
	_active_time_remaining = active_duration
	visible = true
	activate(runtime_source, direction)
	cast_started.emit()
	cooldown_changed.emit(_cooldown_remaining, cooldown_duration)
	return true


## Allows owning controllers and headless validations to tick cooldown explicitly.
func update_cooldown(delta: float) -> void:
	if _cooldown_remaining <= 0.0:
		return
	_cooldown_remaining = maxf(0.0, _cooldown_remaining - delta)
	cooldown_changed.emit(_cooldown_remaining, cooldown_duration)


## Disables the radial hitbox and hides the burst visual.
func deactivate() -> void:
	super.deactivate()
	visible = false
