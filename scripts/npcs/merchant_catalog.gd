extends RefCounted
class_name MerchantCatalog

## Provides deterministic merchant offer metadata for hub shop UI and save rules.
## The catalog is data-only so SaveManager and Hub can share offer definitions safely.

const WINDING_KEY := "winding_key"
const OFFERS := {
	WINDING_KEY: {
		"display_name": "Winding Key",
		"cost": 2,
		"description": "A brass key wound by the hub merchant. Marks the first permanent shop purchase."
	}
}


## Returns a single merchant offer definition, or an empty dictionary for unknown ids.
static func get_offer_definition(offer_id: String) -> Dictionary:
	return OFFERS.get(offer_id, {})


## Returns all offer ids in stable display order.
static func get_offer_ids() -> Array[String]:
	return [WINDING_KEY]
