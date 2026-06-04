extends Node

## Gère la sauvegarde permanente du prototype.
## Pour cette fondation, seules des données minimales sont exposées; les milestones suivants ajouteront upgrades et inventaire permanent.

const SAVE_PATH := "user://roguewatch_save.json"

var permanent_currency: int = 0


## Ajoute de la currency conservée entre les runs et notifie l'UI.
func add_permanent_currency(amount: int) -> void:
	permanent_currency = max(0, permanent_currency + amount)
	SignalBus.permanent_currency_changed.emit(permanent_currency)


## Sérialise les données permanentes dans un dictionnaire simple.
func to_dict() -> Dictionary:
	return {
		"permanent_currency": permanent_currency
	}


## Recharge les données permanentes depuis un dictionnaire validé.
func from_dict(data: Dictionary) -> void:
	permanent_currency = int(data.get("permanent_currency", 0))
	SignalBus.permanent_currency_changed.emit(permanent_currency)
