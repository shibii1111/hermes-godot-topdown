extends CharacterBody2D
class_name EnemyBase

## Common base for clockpunk enemies.
## It handles targeting, simple AI movement, health/damage, contact damage, and minimal drops.

signal died(enemy: Node, currency_value: int)

@export var move_speed: float = 85.0
@export var contact_damage: int = 1
@export var drop_currency: int = 1
@export var hit_flash_time: float = 0.08

@onready var health_component: Node = %HealthComponent
@onready var chase_ai: Node = %EnemyAIChase
@onready var patrol_ai: Node = %EnemyAIPatrol
@onready var body_visual: Polygon2D = %BodyVisual
@onready var contact_hitbox: Node = %ContactHitbox

var target: Node2D = null
var _flash_remaining: float = 0.0
var _base_color: Color = Color.WHITE


## Configures signals and initial enemy values.
func _ready() -> void:
	_base_color = body_visual.color
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


## Chooses chase when possible, otherwise patrol.
func _choose_move_direction(delta: float) -> Vector2:
	var chase_direction: Vector2 = chase_ai.get_chase_direction(self, target)
	if chase_direction != Vector2.ZERO:
		return chase_direction
	return patrol_ai.get_patrol_direction(delta)


## Starts a visual flash when the enemy is hit.
func _on_damaged(_amount: int) -> void:
	_flash_remaining = hit_flash_time
	body_visual.color = Color(1.0, 0.92, 0.72, 1.0)


## Restores the base color after the hit flash.
func _update_hit_flash(delta: float) -> void:
	if _flash_remaining <= 0.0:
		return
	_flash_remaining = maxf(0.0, _flash_remaining - delta)
	if _flash_remaining == 0.0:
		body_visual.color = _base_color


## Emits the drop, then removes the enemy from the scene.
func _on_died() -> void:
	died.emit(self, drop_currency)
	queue_free()
