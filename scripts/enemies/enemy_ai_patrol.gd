extends Node
class_name EnemyAIPatrol

## IA de patrouille lisible: marche dans une direction puis alterne après un délai.

@export var switch_interval: float = 1.25

var _time_remaining: float = 0.0
var _direction_index: int = 0
var _directions: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]


## Retourne une direction de patrouille stable et cyclique.
func get_patrol_direction(delta: float) -> Vector2:
	_time_remaining -= delta
	if _time_remaining <= 0.0:
		_time_remaining = switch_interval
		_direction_index = (_direction_index + 1) % _directions.size()
	return _directions[_direction_index]
