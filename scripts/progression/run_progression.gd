extends RefCounted
class_name RunProgression

## Tracks temporary XP, level, and combat stats for the current dungeon run.
## The data resets each run and deliberately stays separate from permanent hub upgrades.

signal changed(progression: RunProgression)
signal leveled_up(new_level: int, damage_bonus: int)

const BASE_XP_TO_NEXT_LEVEL := 10
const XP_REQUIREMENT_STEP := 5
const DAMAGE_BONUS_PER_LEVEL := 1

var run_currency: int = 0
var total_xp: int = 0
var current_xp: int = 0
var level: int = 1
var xp_to_next_level: int = BASE_XP_TO_NEXT_LEVEL
var enemies_defeated: int = 0
var damage_bonus: int = 0


## Applies one defeated enemy reward, including rollover for multiple level-ups at once.
func grant_enemy_reward(currency_amount: int, xp_amount: int) -> void:
	run_currency += max(0, currency_amount)
	total_xp += max(0, xp_amount)
	current_xp += max(0, xp_amount)
	enemies_defeated += 1
	_process_level_ups()
	changed.emit(self)


## Clears run-only progression values for a new run.
func reset() -> void:
	run_currency = 0
	total_xp = 0
	current_xp = 0
	level = 1
	xp_to_next_level = BASE_XP_TO_NEXT_LEVEL
	enemies_defeated = 0
	damage_bonus = 0
	changed.emit(self)


## Returns an English summary that the HUD can display directly.
func get_stats_text() -> String:
	return "Stats: DMG +%d | Defeated: %d" % [damage_bonus, enemies_defeated]


## Converts accumulated XP into one or more run levels.
func _process_level_ups() -> void:
	while current_xp >= xp_to_next_level:
		current_xp -= xp_to_next_level
		level += 1
		xp_to_next_level = BASE_XP_TO_NEXT_LEVEL + ((level - 1) * XP_REQUIREMENT_STEP)
		damage_bonus = (level - 1) * DAMAGE_BONUS_PER_LEVEL
		leveled_up.emit(level, damage_bonus)
