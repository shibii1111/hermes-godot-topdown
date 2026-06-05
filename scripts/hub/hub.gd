extends Node2D
class_name Hub

## Central hub scene for permanent progression between runs.
## The hub owns UI wiring only; progression rules stay in SaveManager.

const REINFORCED_HEART := "reinforced_heart"
const MERCHANT_OFFER_ID := "winding_key"

@onready var permanent_currency_label: Label = %PermanentCurrencyLabel
@onready var upgrade_status_label: Label = %UpgradeStatusLabel
@onready var upgrade_description_label: Label = %UpgradeDescriptionLabel
@onready var upgrade_button: Button = %UpgradeButton
@onready var merchant_name_label: Label = %MerchantNameLabel
@onready var merchant_offer_label: Label = %MerchantOfferLabel
@onready var merchant_button: Button = %MerchantButton
@onready var run_portal_button: Button = %RunPortalButton
@onready var menu_button: Button = %MenuButton


## Connects hub controls and displays current permanent progression.
func _ready() -> void:
	SignalBus.permanent_currency_changed.connect(_on_progression_changed)
	SignalBus.upgrade_purchased.connect(_on_upgrade_purchased)
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	merchant_button.pressed.connect(_on_merchant_pressed)
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
	_refresh_merchant_state()


## Refreshes the merchant NPC offer using SaveManager purchase state.
func _refresh_merchant_state() -> void:
	merchant_name_label.text = "Brass Merchant"
	var offer := SaveManager.get_merchant_offer_definition(MERCHANT_OFFER_ID)
	var display_name: String = String(offer.get("display_name", "Unknown Wares"))
	var description: String = String(offer.get("description", "No description."))
	var cost: int = int(offer.get("cost", 0))
	merchant_offer_label.text = "%s - %d gears\n%s" % [display_name, cost, description]
	if SaveManager.has_merchant_purchase(MERCHANT_OFFER_ID):
		merchant_button.text = "Purchased"
		merchant_button.disabled = true
	else:
		merchant_button.text = "Buy - %d gears" % cost
		merchant_button.disabled = SaveManager.permanent_currency < cost


## Attempts to buy the selected permanent upgrade and refreshes the station.
func _on_upgrade_pressed() -> void:
	SaveManager.purchase_upgrade(REINFORCED_HEART)
	refresh_hub_state()


## Attempts to buy the first merchant offer and updates the hub shop panel.
func _on_merchant_pressed() -> void:
	SaveManager.purchase_merchant_offer(MERCHANT_OFFER_ID)
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
