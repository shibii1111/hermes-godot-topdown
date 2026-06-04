extends Node

## Intentionally limited global signals to decouple main systems.
## Specialized systems should prefer local signals when that is enough.

signal game_mode_changed(new_mode: int, previous_mode: int)
signal scene_change_requested(scene_path: String)
signal scene_changed(scene_path: String)
signal run_started()
signal run_ended(reason: String)
signal permanent_currency_changed(amount: int)
signal upgrade_purchased(upgrade_id: String, new_level: int)
