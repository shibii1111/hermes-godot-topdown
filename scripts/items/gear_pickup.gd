extends Area2D
class_name GearPickup

## Collectible run-currency pickup dropped by enemies during a dungeon run.
## It only reports the pickup value; the active run controller owns progression state.

signal collected(currency_value: int)

@export var currency_value: int = 1
@export var bob_amplitude: float = 4.0
@export var bob_speed: float = 5.0

@onready var visual: Node2D = %Visual

var _base_visual_position: Vector2 = Vector2.ZERO
var _age: float = 0.0
var _collected: bool = false


## Connects player collision and captures the visual rest position for a small loot idle motion.
func _ready() -> void:
	_base_visual_position = visual.position
	body_entered.connect(_on_body_entered)


## Adds a small readable bob so dropped gears stand out from the floor.
func _process(delta: float) -> void:
	_age += delta
	visual.position = _base_visual_position + Vector2(0.0, sin(_age * bob_speed) * bob_amplitude)


## Emits the pickup reward once when the player touches it, then removes the pickup.
func _on_body_entered(body: Node) -> void:
	if _collected:
		return
	if not body.is_in_group("player"):
		return
	_collected = true
	monitoring = false
	collected.emit(max(0, currency_value))
	queue_free()
