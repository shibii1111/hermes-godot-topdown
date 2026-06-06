extends RefCounted
class_name RunBalance

## Centralizes early prototype balance numbers so pacing can be validated and tuned deliberately.
## This keeps starter progression, rewards, and the first hub upgrade aligned.

const FIRST_LEVEL_XP_REQUIREMENT := 10
const XP_REQUIREMENT_STEP := 5
const DAMAGE_BONUS_PER_LEVEL := 1
const MECHANICAL_RAT_XP := 4
const AUTOMATON_XP := 6
const MECHANICAL_RAT_CURRENCY := 1
const AUTOMATON_CURRENCY := 2
const FIRST_REINFORCED_HEART_COST := 3


## Returns the XP required to reach level 2 from a fresh run.
func get_first_level_xp_requirement() -> int:
	return FIRST_LEVEL_XP_REQUIREMENT


## Returns the cost of the first permanent health upgrade.
func get_first_upgrade_cost() -> int:
	return FIRST_REINFORCED_HEART_COST


## Returns the XP granted by one starter mechanical rat plus one automaton.
func get_starter_encounter_xp() -> int:
	return MECHANICAL_RAT_XP + AUTOMATON_XP


## Returns the run gears granted by one starter mechanical rat plus one automaton.
func get_starter_encounter_currency() -> int:
	return MECHANICAL_RAT_CURRENCY + AUTOMATON_CURRENCY


## Returns a designer-readable snapshot of the starter loop pacing.
func get_starter_balance_summary() -> String:
	return "Starter balance: rat + automaton -> Level 2 and %d gears for Reinforced Heart." % get_starter_encounter_currency()
