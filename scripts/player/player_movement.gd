extends Node
class_name PlayerMovement

## Calcule la vitesse du joueur sans lire les inputs directement.
## Le CharacterBody2D propriétaire reste responsable d'appliquer move_and_slide().

@export var move_speed: float = 180.0


## Retourne la vitesse à appliquer selon l'input et un éventuel dash actif.
func calculate_velocity(move_vector: Vector2, dash_velocity: Vector2) -> Vector2:
	if dash_velocity != Vector2.ZERO:
		return dash_velocity
	if move_vector == Vector2.ZERO:
		return Vector2.ZERO
	return move_vector.normalized() * move_speed
