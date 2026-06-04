extends Node

## Signals globaux volontairement limités pour découpler les systèmes principaux.
## Les systèmes spécialisés doivent préférer des signaux locaux quand c'est suffisant.

signal game_mode_changed(new_mode: int, previous_mode: int)
signal scene_change_requested(scene_path: String)
signal scene_changed(scene_path: String)
signal run_started()
signal run_ended(reason: String)
signal permanent_currency_changed(amount: int)
