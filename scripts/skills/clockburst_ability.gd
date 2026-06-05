extends "res://scripts/combat/hitbox.gd"
class_name ClockburstAbility

## Radial starter spell that bursts clockwork energy around the player.
## It reuses Hitbox damage routing but owns its cooldown and short active window.

signal cast_started()
signal cooldown_changed(remaining: float, duration: float)

@export var cooldown_duration: float = 3.0
@export var active_duration: float = 0.18

@onready var burst_visual: Polygon2D = %BurstVisual
@onready var vfx_ring: Line2D = %VfxRing

var _cooldown_remaining: float = 0.0
var _active_time_remaining: float = 0.0
var _vfx_progress: float = 1.0


## Initializes the radial hitbox in an inactive, ready state.
func _ready() -> void:
	super._ready()
	visible = false
	_vfx_progress = 1.0
	_update_burst_vfx(_vfx_progress)
	vfx_ring.visible = false
	cooldown_changed.emit(_cooldown_remaining, cooldown_duration)


## Advances active hit timing, burst VFX, and cooldown state each physics frame.
func _physics_process(delta: float) -> void:
	if _active_time_remaining > 0.0:
		_active_time_remaining = maxf(0.0, _active_time_remaining - delta)
		_vfx_progress = 1.0 - (_active_time_remaining / active_duration)
		_update_burst_vfx(_vfx_progress)
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
	_vfx_progress = 0.0
	visible = true
	_update_burst_vfx(_vfx_progress)
	vfx_ring.visible = true
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


## Returns normalized burst VFX progress for tuning and headless validation.
func get_vfx_progress() -> float:
	return _vfx_progress


## Returns the current alpha of the primary burst visual.
func get_burst_visual_alpha() -> float:
	return burst_visual.color.a


## Expands and fades the clockwork ring while the damaging window is active.
func _update_burst_vfx(progress: float) -> void:
	var clamped_progress: float = clampf(progress, 0.0, 1.0)
	scale = Vector2.ONE * lerpf(1.0, 1.28, clamped_progress)
	burst_visual.color = Color(0.38, 0.95, 0.82, lerpf(0.78, 0.04, clamped_progress))
	vfx_ring.default_color = Color(1.0, 0.82, 0.35, lerpf(0.95, 0.0, clamped_progress))
	vfx_ring.width = lerpf(5.0, 1.5, clamped_progress)


## Disables the radial hitbox and hides the burst visual.
func deactivate() -> void:
	super.deactivate()
	visible = false
	vfx_ring.visible = false
	scale = Vector2.ONE
