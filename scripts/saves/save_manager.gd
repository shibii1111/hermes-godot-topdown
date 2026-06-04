extends Node

## Manages the prototype's permanent save data.
## This foundation exposes only minimal data; later milestones will add upgrades and permanent inventory.

const SAVE_PATH := "user://roguewatch_save.json"

var permanent_currency: int = 0


## Adds currency kept between runs and notifies the UI.
func add_permanent_currency(amount: int) -> void:
	permanent_currency = max(0, permanent_currency + amount)
	SignalBus.permanent_currency_changed.emit(permanent_currency)


## Serializes permanent data into a simple dictionary.
func to_dict() -> Dictionary:
	return {
		"permanent_currency": permanent_currency
	}


## Reloads permanent data from a validated dictionary.
func from_dict(data: Dictionary) -> void:
	permanent_currency = int(data.get("permanent_currency", 0))
	SignalBus.permanent_currency_changed.emit(permanent_currency)
