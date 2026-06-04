extends Resource
class_name EnemyStats

## Configurable data for a clockpunk enemy.
## Concrete scenes use this resource to avoid magic values in AI.

@export var max_health: int = 3
@export var move_speed: float = 90.0
@export var contact_damage: int = 1
@export var drop_currency: int = 1
@export var aggro_range: float = 260.0
