extends Node
class_name PlayerVisualAnimator

## Lightweight procedural player animation for early polish.
## It only offsets/scales the visual sprite; gameplay movement and combat stay elsewhere.

@export var walk_bob_amplitude: float = 2.5
@export var walk_bob_speed: float = 12.0
@export var dash_stretch: float = 0.08
@export var attack_feedback_time: float = 0.12
@export var attack_pop_scale: float = 0.08

@onready var body_visual: Node2D = %BodyVisual
@onready var dash_trail: Line2D = %DashTrail

var _base_position: Vector2 = Vector2.ZERO
var _base_scale: Vector2 = Vector2.ONE
var _animation_time: float = 0.0
var _attack_time_remaining: float = 0.0
var _current_state: String = "idle"
var _animation_progress: float = 0.0
var _dash_vfx_progress: float = 0.0


## Captures the authored sprite transform so polish can return to the scene baseline.
func _ready() -> void:
	_base_position = body_visual.position
	_base_scale = body_visual.scale
	dash_trail.visible = false
	_apply_idle_pose()


## Updates the sprite-only polish state from already-computed player intent/state.
func update_visuals(delta: float, move_vector: Vector2, is_dashing: bool) -> void:
	_animation_time += delta
	_attack_time_remaining = maxf(0.0, _attack_time_remaining - delta)
	if _attack_time_remaining > 0.0:
		_current_state = "attack"
		_animation_progress = _attack_time_remaining / attack_feedback_time
		_apply_attack_pose()
		return
	if is_dashing:
		_current_state = "dash"
		_animation_progress = 1.0
		_apply_dash_pose()
		return
	if move_vector.length_squared() > 0.01:
		_current_state = "walk"
		_animation_progress = 0.5 + (sin(_animation_time * walk_bob_speed) * 0.5)
		_apply_walk_pose()
		return
	_current_state = "idle"
	_animation_progress = 0.0
	_apply_idle_pose()


## Starts a short attack pop without interacting with weapon damage or cooldowns.
func notify_attack() -> void:
	_attack_time_remaining = attack_feedback_time
	_current_state = "attack"
	_animation_progress = 1.0
	_apply_attack_pose()


## Returns the current visual-only animation state for validations and tuning.
func get_current_state() -> String:
	return _current_state


## Returns a normalized value for the currently active visual polish state.
func get_animation_progress() -> float:
	return _animation_progress


## Returns normalized dash readability VFX progress for validation and tuning.
func get_dash_vfx_progress() -> float:
	return _dash_vfx_progress


func _apply_idle_pose() -> void:
	body_visual.position = _base_position
	body_visual.scale = _base_scale
	dash_trail.visible = false
	_dash_vfx_progress = 0.0


func _apply_walk_pose() -> void:
	body_visual.position = _base_position + Vector2(0.0, sin(_animation_time * walk_bob_speed) * walk_bob_amplitude)
	body_visual.scale = _base_scale * (1.0 + (_animation_progress * 0.025))
	dash_trail.visible = false
	_dash_vfx_progress = 0.0


func _apply_dash_pose() -> void:
	body_visual.position = _base_position
	body_visual.scale = Vector2(_base_scale.x * (1.0 + dash_stretch), _base_scale.y * (1.0 - dash_stretch * 0.5))
	dash_trail.visible = true
	dash_trail.default_color = Color(0.38, 0.95, 0.82, 0.78)
	dash_trail.width = 4.0
	_dash_vfx_progress = 1.0


func _apply_attack_pose() -> void:
	body_visual.position = _base_position
	body_visual.scale = _base_scale * (1.0 + attack_pop_scale * _animation_progress)
	dash_trail.visible = false
	_dash_vfx_progress = 0.0
