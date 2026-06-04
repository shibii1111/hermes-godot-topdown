extends Resource
class_name EnemyStats

## Données configurables d'un ennemi clockpunk.
## Les scènes concrètes utilisent cette ressource pour éviter les valeurs magiques dans l'IA.

@export var max_health: int = 3
@export var move_speed: float = 90.0
@export var contact_damage: int = 1
@export var drop_currency: int = 1
@export var aggro_range: float = 260.0
