extends CharacterBody2D
class_name Player

## Main player scene.
## It assembles specialized components instead of containing all logic in one script.

signal died()
signal health_changed(current_health: int, max_health: int)

@onready var controller: Node = %PlayerController
@onready var movement: Node = %PlayerMovement
@onready var facing: Node = %PlayerFacing
@onready var dash: Node = %PlayerDash
@onready var combat: Node = %PlayerCombat
@onready var health_component: Node = %HealthComponent
@onready var direction_pointer: Node2D = %DirectionPointer


## Connects health signals from the HealthComponent.
func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_died)
	combat.update_weapon_direction(facing.facing_direction)


## Reads player intentions, updates components, then applies movement.
func _physics_process(delta: float) -> void:
	var move_vector: Vector2 = controller.get_move_vector()
	facing.update_facing(move_vector)
	dash.update_dash(delta, controller.wants_dash(), facing.facing_direction)
	combat.update_combat(delta)
	combat.update_weapon_direction(facing.facing_direction)
	_update_direction_pointer()

	if controller.wants_attack():
		combat.try_attack(self)

	velocity = movement.calculate_velocity(move_vector, dash.get_dash_velocity())
	move_and_slide()


## Public entry point for receiving damage from a test zone or enemy.
func receive_damage(damage_data: Resource) -> void:
	health_component.apply_damage(damage_data)


## Rotates the small facing visual indicator in front of the player.
func _update_direction_pointer() -> void:
	direction_pointer.position = facing.facing_direction.normalized() * 22.0
	direction_pointer.rotation = facing.facing_direction.angle()


## Forwards health changes to the test room UI.
func _on_health_changed(current_health: int, max_health: int) -> void:
	health_changed.emit(current_health, max_health)


## Signals player death to the current scene manager.
func _on_died() -> void:
	died.emit()
