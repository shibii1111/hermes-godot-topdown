extends Node2D
class_name Hub

## Central hub scene for permanent progression between runs.
## The hub owns UI wiring only; progression rules stay in SaveManager.

const REINFORCED_HEART := "reinforced_heart"

@onready var permanent_currency_label: Label = %PermanentCurrencyLabel
@onready var upgrade_status_label: Label = %UpgradeStatusLabel
@onready var upgrade_description_label: Label = %UpgradeDescriptionLabel
@onready var upgrade_button: Button = %UpgradeButton
@onready var run_portal_button: Button = %RunPortalButton
@onready var menu_button: Button = %MenuButton


## Connects hub controls and displays current permanent progression.
func _ready() -> void:
	SignalBus.permanent_currency_changed.connect(_on_progression_changed)
	SignalBus.upgrade_purchased.connect(_on_upgrade_purchased)
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	run_portal_button.pressed.connect(_on_start_run_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	refresh_hub_state()
	run_portal_button.grab_focus()


## Refreshes all hub UI labels and upgrade button state from SaveManager.
func refresh_hub_state() -> void:
	permanent_currency_label.text = "Permanent gears: %d" % SaveManager.permanent_currency
	var definition := SaveManager.get_upgrade_definition(REINFORCED_HEART)
	var level := SaveManager.get_upgrade_level(REINFORCED_HEART)
	var max_level: int = int(definition.get("max_level", 0))
	var display_name: String = String(definition.get("display_name", "Unknown Upgrade"))
	upgrade_status_label.text = "%s Lv. %d / %d" % [display_name, level, max_level]
	upgrade_description_label.text = String(definition.get("description", "No description."))
	if SaveManager.is_upgrade_maxed(REINFORCED_HEART):
		upgrade_button.text = "Max Level"
		upgrade_button.disabled = true
	else:
		var cost := SaveManager.get_upgrade_cost(REINFORCED_HEART)
		upgrade_button.text = "Upgrade - %d gears" % cost
		upgrade_button.disabled = SaveManager.permanent_currency < cost


## Attempts to buy the selected permanent upgrade and refreshes the station.
func _on_upgrade_pressed() -> void:
	SaveManager.purchase_upgrade(REINFORCED_HEART)
	refresh_hub_state()


## Starts a prototype run through the SceneLoader.
func _on_start_run_pressed() -> void:
	SceneLoader.start_run()


## Returns to the start menu to validate basic navigation.
func _on_menu_pressed() -> void:
	SceneLoader.go_to_start_menu()


## Refreshes labels when permanent currency changes.
func _on_progression_changed(_amount: int) -> void:
	refresh_hub_state()


## Refreshes labels when an upgrade is purchased.
func _on_upgrade_purchased(_upgrade_id: String, _new_level: int) -> void:
	refresh_hub_state()
