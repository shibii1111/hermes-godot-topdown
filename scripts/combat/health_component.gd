extends Node
class_name HealthComponent

## Composant de vie réutilisable pour joueur, ennemis et objets destructibles.
## Il ne connaît pas le type de propriétaire: il signale seulement les changements de santé et la mort.

signal health_changed(current_health: int, max_health: int)
signal damaged(amount: int)
signal died()

@export var max_health: int = 5

var current_health: int = 5


## Initialise la vie courante au maximum configuré.
func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)


## Applique des dégâts bornés et émet died() quand la vie atteint zéro.
func apply_damage(damage_data: Resource) -> void:
	if current_health <= 0:
		return
	var amount: int = max(0, int(damage_data.amount))
	current_health = maxi(0, current_health - amount)
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)
	if current_health == 0:
		died.emit()


## Rend de la vie sans dépasser le maximum.
func heal(amount: int) -> void:
	if amount <= 0 or current_health <= 0:
		return
	current_health = mini(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)


## Retourne vrai si le propriétaire n'a plus de vie.
func is_dead() -> bool:
	return current_health <= 0
