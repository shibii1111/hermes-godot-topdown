extends Node
class_name PlayerController

## Lit les inputs joueur sans appliquer directement de gameplay.
## Cette séparation permet de remplacer plus tard les inputs par une IA, un replay ou un tutoriel.


## Retourne le vecteur de déplacement normalisé depuis clavier, souris ou manette.
func get_move_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


## Indique si le joueur vient de demander une attaque melee.
func wants_attack() -> bool:
	return Input.is_action_just_pressed("attack")


## Indique si le joueur vient de demander un dash.
func wants_dash() -> bool:
	return Input.is_action_just_pressed("dash")


## Indique si le joueur vient de demander le spell ou special attack.
func wants_special() -> bool:
	return Input.is_action_just_pressed("special")
