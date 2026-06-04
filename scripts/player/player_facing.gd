extends Node
class_name PlayerFacing

## Tracks the direction the character is facing.
## Attacks use this direction instead of the right stick to avoid a twin-stick feel.

const DEFAULT_FACING := Vector2.DOWN

var facing_direction: Vector2 = DEFAULT_FACING


## Updates direction only when the player provides meaningful movement.
func update_facing(move_vector: Vector2) -> void:
	if move_vector.length_squared() < 0.01:
		return
	facing_direction = move_vector.normalized()


## Returns the nearest cardinal direction, useful for 4-direction animations.
func get_cardinal_facing() -> Vector2:
	if absf(facing_direction.x) > absf(facing_direction.y):
		return Vector2.RIGHT if facing_direction.x > 0.0 else Vector2.LEFT
	return Vector2.DOWN if facing_direction.y > 0.0 else Vector2.UP
