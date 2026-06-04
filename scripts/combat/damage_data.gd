extends Resource
class_name DamageData

## Données transférées par une attaque.
## Utiliser une ressource évite de passer des dictionnaires fragiles entre hitboxes et health components.

@export var amount: int = 1
@export var knockback: float = 0.0

var source: Node = null
var direction: Vector2 = Vector2.ZERO


## Configure les champs runtime non exportés avant d'envoyer les dégâts.
func configure(runtime_source: Node, hit_direction: Vector2) -> DamageData:
	source = runtime_source
	direction = hit_direction.normalized()
	return self
