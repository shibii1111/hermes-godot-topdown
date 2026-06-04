extends Area2D
class_name DamageZone

const DamageDataScript := preload("res://scripts/combat/damage_data.gd")

## Zone de test qui inflige des dégâts périodiques au joueur.
## Elle rend le système health/damage vérifiable dès Milestone 1 sans attendre les ennemis.

@export var damage_per_tick: int = 1
@export var tick_interval: float = 0.75

var _bodies_in_zone: Array[Node] = []
var _tick_remaining: float = 0.0


## Connecte les signaux d'entrée/sortie et initialise le timer de dégâts.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_tick_remaining = tick_interval


## Applique les dégâts périodiques aux bodies compatibles présents dans la zone.
func _physics_process(delta: float) -> void:
	if _bodies_in_zone.is_empty():
		_tick_remaining = tick_interval
		return
	_tick_remaining -= delta
	if _tick_remaining > 0.0:
		return
	_tick_remaining = tick_interval
	for body in _bodies_in_zone:
		_apply_damage_to(body)


## Ajoute un body à la liste et applique un premier dégât immédiat.
func _on_body_entered(body: Node) -> void:
	if _bodies_in_zone.has(body):
		return
	_bodies_in_zone.append(body)
	_apply_damage_to(body)


## Retire un body sorti de la zone de dégâts.
func _on_body_exited(body: Node) -> void:
	_bodies_in_zone.erase(body)


## Envoie un DamageData au body si celui-ci expose receive_damage().
func _apply_damage_to(body: Node) -> void:
	if not body.has_method("receive_damage"):
		return
	var damage_data: Resource = DamageDataScript.new()
	damage_data.amount = damage_per_tick
	body.receive_damage(damage_data.configure(self, Vector2.ZERO))
