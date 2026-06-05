extends CharacterBody2D
class_name EnemyBase

## Common base for clockpunk enemies.
## It handles targeting, simple AI movement, health/damage, contact damage, and minimal drops.

signal died(enemy: Node, currency_value: int, xp_value: int)

@export var move_speed: float = 85.0
@export var contact_damage: int = 1
@export var drop_currency: int = 1
@export var drop_xp: int = 2
@export var hit_flash_time: float = 0.08
@export var death_vfx_scale: float = 1.25

@onready var health_component: Node = %HealthComponent
@onready var chase_ai: Node = %EnemyAIChase
@onready var patrol_ai: Node = %EnemyAIPatrol
@onready var body_visual: CanvasItem = %BodyVisual
@onready var contact_hitbox: Node = %ContactHitbox
@onready var hit_spark: Line2D = %HitSpark
@onready var death_spark: Line2D = %DeathSpark

var target: Node2D = null
var _flash_remaining: float = 0.0
var _base_modulate: Color = Color.WHITE
var _hit_vfx_progress: float = 0.0
var _death_vfx_progress: float = 0.0
var _base_body_scale: Vector2 = Vector2.ONE


## Configures signals and initial enemy values.
func _ready() -> void:
	_base_modulate = body_visual.modulate
	if body_visual is Node2D:
		_base_body_scale = (body_visual as Node2D).scale
	hit_spark.visible = false
	death_spark.visible = false
	health_component.damaged.connect(_on_damaged)
	health_component.died.connect(_on_died)
	contact_hitbox.damage_amount = contact_damage
	contact_hitbox.activate(self, Vector2.ZERO)


## Updates AI, movement, and hit visual feedback.
func _physics_process(delta: float) -> void:
	_update_hit_flash(delta)
	var direction := _choose_move_direction(delta)
	velocity = direction * move_speed
	move_and_slide()


## Sets the target chased by the enemy.
func set_target(next_target: Node2D) -> void:
	target = next_target


## Entry point for receiving damage from a player hitbox.
func receive_damage(damage_data: Resource) -> void:
	health_component.apply_damage(damage_data)


## Returns normalized hit VFX intensity for validation and tuning.
func get_hit_vfx_progress() -> float:
	return _hit_vfx_progress


## Returns normalized death VFX intensity for validation and tuning.
func get_death_vfx_progress() -> float:
	return _death_vfx_progress


## Chooses chase when possible, otherwise patrol.
func _choose_move_direction(delta: float) -> Vector2:
	var chase_direction: Vector2 = chase_ai.get_chase_direction(self, target)
	if chase_direction != Vector2.ZERO:
		return chase_direction
	return patrol_ai.get_patrol_direction(delta)


## Starts a visual flash when the enemy is hit.
func _on_damaged(_amount: int) -> void:
	_flash_remaining = hit_flash_time
	_hit_vfx_progress = 1.0
	body_visual.modulate = Color(1.0, 0.92, 0.72, 1.0)
	hit_spark.visible = true
	hit_spark.default_color = Color(1.0, 0.86, 0.36, 0.9)
	hit_spark.width = 3.0


## Restores the base color after the hit flash.
func _update_hit_flash(delta: float) -> void:
	if _flash_remaining <= 0.0:
		return
	_flash_remaining = maxf(0.0, _flash_remaining - delta)
	_hit_vfx_progress = _flash_remaining / hit_flash_time
	hit_spark.default_color = Color(1.0, 0.86, 0.36, 0.9 * _hit_vfx_progress)
	if _flash_remaining == 0.0:
		body_visual.modulate = _base_modulate
		hit_spark.visible = false
		_hit_vfx_progress = 0.0


## Shows an immediate death spark/pop while keeping death rewards and removal deterministic.
func _play_death_vfx() -> void:
	_death_vfx_progress = 1.0
	death_spark.visible = true
	death_spark.default_color = Color(1.0, 0.55, 0.28, 0.94)
	death_spark.width = 5.0
	if body_visual is Node2D:
		(body_visual as Node2D).scale = _base_body_scale * death_vfx_scale


## Emits the run rewards, then removes the enemy from the scene.
func _on_died() -> void:
	_play_death_vfx()
	died.emit(self, drop_currency, drop_xp)
	queue_free()
