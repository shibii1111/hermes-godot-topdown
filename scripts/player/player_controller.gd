extends Node
class_name PlayerController

## Reads player inputs without directly applying gameplay.
## This separation allows inputs to be replaced later by AI, replay, or tutorial control.


## Returns the normalized movement vector from keyboard, mouse, or controller.
func get_move_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


## Indicates whether the player just requested a melee attack.
func wants_attack() -> bool:
	return Input.is_action_just_pressed("attack")


## Indicates whether the player just requested a dash.
func wants_dash() -> bool:
	return Input.is_action_just_pressed("dash")


## Indicates whether the player just requested the spell or special attack.
func wants_special() -> bool:
	return Input.is_action_just_pressed("special")
