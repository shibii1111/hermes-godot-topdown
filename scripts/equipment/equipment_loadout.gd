extends RefCounted
class_name EquipmentLoadout

## Owns the currently equipped run items by slot.
## Bonuses are aggregated here so gameplay systems do not need to know every item.

signal changed(loadout: EquipmentLoadout)

var equipped_items: Dictionary = {}


## Equips or replaces an item in its slot, then notifies listeners.
func equip_item(item: EquipmentItem) -> void:
	if item == null or item.slot == "":
		return
	equipped_items[item.slot] = item
	changed.emit(self)


## Returns the item equipped in a slot, or null when the slot is empty.
func get_equipped_item(slot: String) -> EquipmentItem:
	return equipped_items.get(slot, null)


## Aggregates all equipped damage bonuses.
func get_damage_bonus() -> int:
	var total := 0
	for item: EquipmentItem in equipped_items.values():
		total += item.damage_bonus
	return total


## Returns a readable one-line summary for the inventory overlay.
func get_summary_text() -> String:
	if equipped_items.is_empty():
		return "Weapon: None | Gear: No bonus"
	var weapon: EquipmentItem = get_equipped_item("weapon")
	var weapon_name := "None"
	if weapon != null:
		weapon_name = weapon.display_name
	var damage_bonus := get_damage_bonus()
	return "Weapon: %s | Gear: DMG +%d" % [weapon_name, damage_bonus]
