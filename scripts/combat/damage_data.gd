extends Resource
class_name DamageData

## Data transferred by an attack.
## Using a resource avoids passing fragile dictionaries between hitboxes and health components.

@export var amount: int = 1
@export var knockback: float = 0.0

var source: Node = null
var direction: Vector2 = Vector2.ZERO


## Configures non-exported runtime fields before sending damage.
func configure(runtime_source: Node, hit_direction: Vector2) -> DamageData:
	source = runtime_source
	direction = hit_direction.normalized()
	return self
