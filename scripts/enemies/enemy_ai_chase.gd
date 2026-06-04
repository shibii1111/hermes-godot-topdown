extends Node
class_name EnemyAIChase

## IA simple de poursuite: si une cible est dans la portée d'aggro, retourner une direction vers elle.

@export var aggro_range: float = 260.0


## Calcule la direction de chase vers la cible, ou zéro si aucune cible valide/proche.
func get_chase_direction(owner_node: Node2D, target: Node2D) -> Vector2:
	if owner_node == null or target == null:
		return Vector2.ZERO
	var to_target := target.global_position - owner_node.global_position
	if to_target.length() > aggro_range:
		return Vector2.ZERO
	return to_target.normalized()
