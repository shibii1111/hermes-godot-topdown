extends Area2D
class_name GearPickup

## Collectible run-currency pickup dropped by enemies during a dungeon run.
## It only reports the pickup value; the active run controller owns progression state.

signal collected(currency_value: int)

@export var currency_value: int = 1
@export var bob_amplitude: float = 4.0
@export var bob_speed: float = 5.0
@export var collect_pop_scale: float = 1.35

@onready var visual: Node2D = %Visual
@onready var collect_spark: Line2D = %CollectSpark

var _base_visual_position: Vector2 = Vector2.ZERO
var _age: float = 0.0
var _collected: bool = false
var _collect_vfx_progress: float = 0.0


## Connects player collision and captures the visual rest position for a small loot idle motion.
func _ready() -> void:
	_base_visual_position = visual.position
	collect_spark.visible = false
	body_entered.connect(_on_body_entered)


## Adds a small readable bob so dropped gears stand out from the floor.
func _process(delta: float) -> void:
	if _collected:
		return
	_age += delta
	visual.position = _base_visual_position + Vector2(0.0, sin(_age * bob_speed) * bob_amplitude)


## Returns normalized collect micro-VFX progress for validation and tuning.
func get_collect_vfx_progress() -> float:
	return _collect_vfx_progress


## Emits the pickup reward once when the player touches it, then removes the pickup.
func _on_body_entered(body: Node) -> void:
	if _collected:
		return
	if not body.is_in_group("player"):
		return
	_collected = true
	set_deferred("monitoring", false)
	_play_collect_vfx()
	collected.emit(max(0, currency_value))
	queue_free()


## Creates an immediate gear-pop sparkle before the pickup leaves the scene tree.
func _play_collect_vfx() -> void:
	_collect_vfx_progress = 1.0
	visual.position = _base_visual_position
	visual.scale = Vector2.ONE * collect_pop_scale
	collect_spark.visible = true
	collect_spark.default_color = Color(1.0, 0.82, 0.35, 0.92)
