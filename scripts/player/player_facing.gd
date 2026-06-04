extends Node
class_name PlayerFacing

## Suit la direction où le personnage regarde.
## Les attaques utilisent cette direction plutôt que le stick droit pour éviter le feeling twin-stick.

const DEFAULT_FACING := Vector2.DOWN

var facing_direction: Vector2 = DEFAULT_FACING


## Met à jour la direction seulement quand le joueur fournit un mouvement significatif.
func update_facing(move_vector: Vector2) -> void:
	if move_vector.length_squared() < 0.01:
		return
	facing_direction = move_vector.normalized()


## Retourne la direction cardinale la plus proche, utile pour animations 4 directions.
func get_cardinal_facing() -> Vector2:
	if absf(facing_direction.x) > absf(facing_direction.y):
		return Vector2.RIGHT if facing_direction.x > 0.0 else Vector2.LEFT
	return Vector2.DOWN if facing_direction.y > 0.0 else Vector2.UP
