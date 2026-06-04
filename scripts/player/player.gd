extends CharacterBody2D
class_name Player

## Scène joueur principale.
## Elle assemble les composants spécialisés au lieu de contenir toute la logique dans un seul script.

signal died()
signal health_changed(current_health: int, max_health: int)

@onready var controller: Node = %PlayerController
@onready var movement: Node = %PlayerMovement
@onready var facing: Node = %PlayerFacing
@onready var dash: Node = %PlayerDash
@onready var combat: Node = %PlayerCombat
@onready var health_component: Node = %HealthComponent
@onready var direction_pointer: Node2D = %DirectionPointer


## Connecte les signaux de santé du composant HealthComponent.
func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_died)
	combat.update_weapon_direction(facing.facing_direction)


## Lit les intentions du joueur, met à jour les composants, puis applique le déplacement.
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


## Point d'entrée public pour recevoir des dégâts depuis une zone de test ou un ennemi.
func receive_damage(damage_data: Resource) -> void:
	health_component.apply_damage(damage_data)


## Oriente le petit indicateur visuel de facing devant le joueur.
func _update_direction_pointer() -> void:
	direction_pointer.position = facing.facing_direction.normalized() * 22.0
	direction_pointer.rotation = facing.facing_direction.angle()


## Remonte les changements de vie vers l'UI de la salle de test.
func _on_health_changed(current_health: int, max_health: int) -> void:
	health_changed.emit(current_health, max_health)


## Signale la mort du joueur au gestionnaire de scène courant.
func _on_died() -> void:
	died.emit()
