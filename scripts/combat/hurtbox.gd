extends Area2D
class_name Hurtbox

## Zone qui reçoit des dégâts et les redirige vers un HealthComponent.
## Elle permet à un objet de recevoir des hits sans exposer toute sa scène.

@export var health_component_path: NodePath

@onready var health_component: Node = get_node_or_null(health_component_path)


## Transmet les dégâts reçus au composant de vie configuré.
func receive_damage(damage_data: Resource) -> void:
	if health_component == null:
		push_warning("Hurtbox sans HealthComponent: %s" % name)
		return
	health_component.apply_damage(damage_data)
