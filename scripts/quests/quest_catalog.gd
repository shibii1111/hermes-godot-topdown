extends RefCounted
class_name QuestCatalog

## Provides deterministic quest metadata for hub quest givers and save rules.
## Quest progress is stored by SaveManager; this catalog remains data-only.

const COLLECT_3_GEARS := "collect_3_gears"
const QUESTS := {
	COLLECT_3_GEARS: {
		"display_name": "First Haul",
		"target_amount": 3,
		"reward_gears": 1,
		"description": "Collect 3 run gears, return to the hub, and claim a small permanent reward."
	}
}


## Returns a quest definition, or an empty dictionary for unknown ids.
static func get_quest_definition(quest_id: String) -> Dictionary:
	return QUESTS.get(quest_id, {})


## Returns all quest ids in stable display order.
static func get_quest_ids() -> Array[String]:
	return [COLLECT_3_GEARS]
