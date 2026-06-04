extends Node

## Centralise l'état haut niveau du jeu sans contenir de logique gameplay lourde.
## Cet autoload sert à coordonner les transitions start menu, hub, run et pause.

enum Mode {
	START_MENU,
	HUB,
	RUN,
	PAUSED
}

var current_mode: Mode = Mode.START_MENU
var previous_mode: Mode = Mode.START_MENU


## Change le mode courant et émet un signal global pour permettre à l'UI de réagir.
func set_mode(next_mode: Mode) -> void:
	if current_mode == next_mode:
		return
	previous_mode = current_mode
	current_mode = next_mode
	SignalBus.game_mode_changed.emit(current_mode, previous_mode)


## Indique si le joueur est actuellement dans une run de donjon.
func is_run_active() -> bool:
	return current_mode == Mode.RUN


## Indique si le jeu est actuellement dans le hub central.
func is_in_hub() -> bool:
	return current_mode == Mode.HUB
