extends Node
class_name EnemyAIChase

## Simple chase AI: if a target is within aggro range, returns a direction toward it.

@export var aggro_range: float = 260.0


## Computes the chase direction toward the target, or zero if no valid/nearby target exists.
func get_chase_direction(owner_node: Node2D, target: Node2D) -> Vector2:
	if owner_node == null or target == null:
		return Vector2.ZERO
	var to_target := target.global_position - owner_node.global_position
	if to_target.length() > aggro_range:
		return Vector2.ZERO
	return to_target.normalized()
