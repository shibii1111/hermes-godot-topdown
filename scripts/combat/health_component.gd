extends Node
class_name HealthComponent

## Reusable health component for players, enemies, and destructible objects.
## It does not know the owner type: it only signals health changes and death.

signal health_changed(current_health: int, max_health: int)
signal damaged(amount: int)
signal died()

@export var max_health: int = 5

var current_health: int = 5


## Initializes current health to the configured maximum.
func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)


## Applies clamped damage and emits died() when health reaches zero.
func apply_damage(damage_data: Resource) -> void:
	if current_health <= 0:
		return
	var amount: int = max(0, int(damage_data.amount))
	current_health = maxi(0, current_health - amount)
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)
	if current_health == 0:
		died.emit()


## Restores health without exceeding the maximum.
func heal(amount: int) -> void:
	if amount <= 0 or current_health <= 0:
		return
	current_health = mini(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)


## Returns true if the owner has no health left.
func is_dead() -> bool:
	return current_health <= 0
