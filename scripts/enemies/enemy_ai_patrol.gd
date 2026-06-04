extends Node
class_name EnemyAIPatrol

## Readable patrol AI: moves in one direction, then switches after a delay.

@export var switch_interval: float = 1.25

var _time_remaining: float = 0.0
var _direction_index: int = 0
var _directions: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]


## Returns a stable cyclic patrol direction.
func get_patrol_direction(delta: float) -> Vector2:
	_time_remaining -= delta
	if _time_remaining <= 0.0:
		_time_remaining = switch_interval
		_direction_index = (_direction_index + 1) % _directions.size()
	return _directions[_direction_index]
