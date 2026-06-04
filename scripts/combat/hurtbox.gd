extends Area2D
class_name Hurtbox

## Area that receives damage and redirects it to a HealthComponent.
## It allows an object to receive hits without exposing its whole scene.

@export var health_component_path: NodePath

@onready var health_component: Node = get_node_or_null(health_component_path)


## Forwards received damage to the configured health component.
func receive_damage(damage_data: Resource) -> void:
	if health_component == null:
		push_warning("Hurtbox without HealthComponent: %s" % name)
		return
	health_component.apply_damage(damage_data)
