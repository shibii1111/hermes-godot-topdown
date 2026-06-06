extends Node

## Manages permanent progression and save data for the roguelite loop.
## Run scenes award gears here, while the hub spends them on persistent upgrades.

const DEFAULT_SAVE_PATH := "user://roguewatch_save.json"
const REINFORCED_HEART := "reinforced_heart"
const RunBalanceScript := preload("res://scripts/balance/run_balance.gd")
const MerchantCatalogScript := preload("res://scripts/npcs/merchant_catalog.gd")
const QuestCatalogScript := preload("res://scripts/quests/quest_catalog.gd")
const UPGRADE_DEFINITIONS := {
	REINFORCED_HEART: {
		"display_name": "Reinforced Heart",
		"base_cost": RunBalanceScript.FIRST_REINFORCED_HEART_COST,
		"max_level": 3,
		"description": "+1 max health per level for future runs."
	}
}

var permanent_currency: int = 0
var upgrade_levels: Dictionary = {}
var merchant_purchases: Dictionary = {}
var quest_progress: Dictionary = {}
var claimed_quest_rewards: Dictionary = {}
var _save_path: String = DEFAULT_SAVE_PATH


## Loads saved progression when the autoload is created.
func _ready() -> void:
	load_game()


## Allows validation scripts to use an isolated save file.
func set_save_path(next_save_path: String) -> void:
	_save_path = next_save_path


## Clears in-memory progression for deterministic validation scripts.
func reset_for_tests() -> void:
	permanent_currency = 0
	upgrade_levels.clear()
	merchant_purchases.clear()
	quest_progress.clear()
	claimed_quest_rewards.clear()
	SignalBus.permanent_currency_changed.emit(permanent_currency)
	SignalBus.upgrade_purchased.emit(REINFORCED_HEART, 0)


## Adds currency kept between runs and notifies the UI.
func add_permanent_currency(amount: int) -> void:
	permanent_currency = max(0, permanent_currency + amount)
	SignalBus.permanent_currency_changed.emit(permanent_currency)


## Attempts to buy one level of a permanent upgrade.
func purchase_upgrade(upgrade_id: String) -> bool:
	if not UPGRADE_DEFINITIONS.has(upgrade_id):
		return false
	var current_level := get_upgrade_level(upgrade_id)
	var max_level: int = int(UPGRADE_DEFINITIONS[upgrade_id].get("max_level", 0))
	if current_level >= max_level:
		return false
	var cost := get_upgrade_cost(upgrade_id)
	if permanent_currency < cost:
		return false
	permanent_currency -= cost
	upgrade_levels[upgrade_id] = current_level + 1
	SignalBus.permanent_currency_changed.emit(permanent_currency)
	SignalBus.upgrade_purchased.emit(upgrade_id, current_level + 1)
	save_game()
	return true


## Attempts to buy a permanent merchant offer once.
func purchase_merchant_offer(offer_id: String) -> bool:
	var definition := MerchantCatalogScript.get_offer_definition(offer_id)
	if definition.is_empty() or has_merchant_purchase(offer_id):
		return false
	var cost: int = int(definition.get("cost", 0))
	if permanent_currency < cost:
		return false
	permanent_currency -= cost
	merchant_purchases[offer_id] = true
	SignalBus.permanent_currency_changed.emit(permanent_currency)
	save_game()
	return true


## Returns true when a permanent merchant offer has already been bought.
func has_merchant_purchase(offer_id: String) -> bool:
	return bool(merchant_purchases.get(offer_id, false))


## Exposes merchant offer metadata to hub UI without duplicating catalog data.
func get_merchant_offer_definition(offer_id: String) -> Dictionary:
	return MerchantCatalogScript.get_offer_definition(offer_id)


## Adds clamped progress to a saved quest objective.
func add_quest_progress(quest_id: String, amount: int) -> void:
	var definition := QuestCatalogScript.get_quest_definition(quest_id)
	if definition.is_empty() or amount <= 0 or is_quest_completed(quest_id):
		return
	var target_amount: int = int(definition.get("target_amount", 0))
	var next_progress: int = min(target_amount, get_quest_progress(quest_id) + amount)
	quest_progress[quest_id] = next_progress
	save_game()


## Returns current saved progress for a quest objective.
func get_quest_progress(quest_id: String) -> int:
	return int(quest_progress.get(quest_id, 0))


## Returns true once quest progress reaches the catalog target.
func is_quest_completed(quest_id: String) -> bool:
	var definition := QuestCatalogScript.get_quest_definition(quest_id)
	if definition.is_empty():
		return false
	return get_quest_progress(quest_id) >= int(definition.get("target_amount", 0))


## Attempts to claim a completed quest reward once.
func claim_quest_reward(quest_id: String) -> bool:
	if not is_quest_completed(quest_id) or is_quest_reward_claimed(quest_id):
		return false
	var definition := QuestCatalogScript.get_quest_definition(quest_id)
	permanent_currency += max(0, int(definition.get("reward_gears", 0)))
	claimed_quest_rewards[quest_id] = true
	SignalBus.permanent_currency_changed.emit(permanent_currency)
	save_game()
	return true


## Returns true when a quest reward was already claimed.
func is_quest_reward_claimed(quest_id: String) -> bool:
	return bool(claimed_quest_rewards.get(quest_id, false))


## Exposes quest metadata to hub UI without duplicating catalog data.
func get_quest_definition(quest_id: String) -> Dictionary:
	return QuestCatalogScript.get_quest_definition(quest_id)


## Returns the current purchased level for a permanent upgrade.
func get_upgrade_level(upgrade_id: String) -> int:
	return int(upgrade_levels.get(upgrade_id, 0))


## Returns the cost of the next upgrade level.
func get_upgrade_cost(upgrade_id: String) -> int:
	if not UPGRADE_DEFINITIONS.has(upgrade_id):
		return 0
	var base_cost: int = int(UPGRADE_DEFINITIONS[upgrade_id].get("base_cost", 0))
	return base_cost + get_upgrade_level(upgrade_id) * 2


## Returns true when the upgrade cannot be bought anymore.
func is_upgrade_maxed(upgrade_id: String) -> bool:
	if not UPGRADE_DEFINITIONS.has(upgrade_id):
		return true
	return get_upgrade_level(upgrade_id) >= int(UPGRADE_DEFINITIONS[upgrade_id].get("max_level", 0))


## Returns the display metadata for a permanent upgrade.
func get_upgrade_definition(upgrade_id: String) -> Dictionary:
	return UPGRADE_DEFINITIONS.get(upgrade_id, {})


## Converts permanent heart upgrades into player max health bonus.
func get_player_max_health_bonus() -> int:
	return get_upgrade_level(REINFORCED_HEART)


## Saves permanent progression to disk as JSON.
func save_game() -> bool:
	var file := FileAccess.open(_save_path, FileAccess.WRITE)
	if file == null:
		push_warning("Unable to open save file for writing: %s" % _save_path)
		return false
	file.store_string(JSON.stringify(to_dict(), "\t"))
	return true


## Loads permanent progression from disk if a save exists.
func load_game() -> bool:
	if not FileAccess.file_exists(_save_path):
		return false
	var file := FileAccess.open(_save_path, FileAccess.READ)
	if file == null:
		push_warning("Unable to open save file for reading: %s" % _save_path)
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Save file is not a valid dictionary: %s" % _save_path)
		return false
	from_dict(parsed)
	return true


## Serializes permanent data into a simple dictionary.
func to_dict() -> Dictionary:
	return {
		"permanent_currency": permanent_currency,
		"upgrade_levels": upgrade_levels,
		"merchant_purchases": merchant_purchases,
		"quest_progress": quest_progress,
		"claimed_quest_rewards": claimed_quest_rewards
	}


## Reloads permanent data from a validated dictionary.
func from_dict(data: Dictionary) -> void:
	permanent_currency = max(0, int(data.get("permanent_currency", 0)))
	upgrade_levels.clear()
	merchant_purchases.clear()
	quest_progress.clear()
	claimed_quest_rewards.clear()
	var saved_upgrades: Dictionary = data.get("upgrade_levels", {})
	for upgrade_id in saved_upgrades.keys():
		upgrade_levels[String(upgrade_id)] = max(0, int(saved_upgrades[upgrade_id]))
	var saved_merchant_purchases: Dictionary = data.get("merchant_purchases", {})
	for offer_id in saved_merchant_purchases.keys():
		merchant_purchases[String(offer_id)] = bool(saved_merchant_purchases[offer_id])
	var saved_quest_progress: Dictionary = data.get("quest_progress", {})
	for quest_id in saved_quest_progress.keys():
		quest_progress[String(quest_id)] = max(0, int(saved_quest_progress[quest_id]))
	var saved_claimed_quest_rewards: Dictionary = data.get("claimed_quest_rewards", {})
	for quest_id in saved_claimed_quest_rewards.keys():
		claimed_quest_rewards[String(quest_id)] = bool(saved_claimed_quest_rewards[quest_id])
	SignalBus.permanent_currency_changed.emit(permanent_currency)
	for upgrade_id in upgrade_levels.keys():
		SignalBus.upgrade_purchased.emit(upgrade_id, get_upgrade_level(upgrade_id))
