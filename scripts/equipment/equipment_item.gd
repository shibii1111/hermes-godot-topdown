extends RefCounted
class_name EquipmentItem

## Describes one equipped item and the run stat bonuses it contributes.
## The item is data-only so inventory, HUD, and run progression can share it safely.

var item_id: String = ""
var display_name: String = ""
var slot: String = ""
var damage_bonus: int = 0
var description: String = ""


## Builds an equipment item with explicit readable data.
func configure(next_item_id: String, next_display_name: String, next_slot: String, next_damage_bonus: int, next_description: String) -> EquipmentItem:
	item_id = next_item_id
	display_name = next_display_name
	slot = next_slot
	damage_bonus = max(0, next_damage_bonus)
	description = next_description
	return self


## Creates the starter weapon used by the M6.3 equipment slice.
static func create_clockwork_blade() -> EquipmentItem:
	return EquipmentItem.new().configure(
		"clockwork_blade",
		"Clockwork Blade",
		"weapon",
		1,
		"A reliable gear-driven blade. Adds DMG +1 during the run."
	)


## Returns a compact English label for inventory and HUD summaries.
func get_bonus_text() -> String:
	if damage_bonus <= 0:
		return "No bonus"
	return "DMG +%d" % damage_bonus
