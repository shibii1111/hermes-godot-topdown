extends Node
class_name PlayerMovement

## Computes player velocity without reading inputs directly.
## The owning CharacterBody2D remains responsible for applying move_and_slide().

@export var move_speed: float = 180.0


## Returns the velocity to apply based on input and any active dash.
func calculate_velocity(move_vector: Vector2, dash_velocity: Vector2) -> Vector2:
	if dash_velocity != Vector2.ZERO:
		return dash_velocity
	if move_vector == Vector2.ZERO:
		return Vector2.ZERO
	return move_vector.normalized() * move_speed
