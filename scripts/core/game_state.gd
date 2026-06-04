extends Node

## Centralizes high-level game state without containing heavy gameplay logic.
## This autoload coordinates transitions between start menu, hub, run, and pause.

enum Mode {
	START_MENU,
	HUB,
	RUN,
	PAUSED
}

var current_mode: Mode = Mode.START_MENU
var previous_mode: Mode = Mode.START_MENU


## Changes the current mode and emits a global signal so the UI can react.
func set_mode(next_mode: Mode) -> void:
	if current_mode == next_mode:
		return
	previous_mode = current_mode
	current_mode = next_mode
	SignalBus.game_mode_changed.emit(current_mode, previous_mode)


## Indicates whether the player is currently in a dungeon run.
func is_run_active() -> bool:
	return current_mode == Mode.RUN


## Indicates whether the game is currently in the central hub.
func is_in_hub() -> bool:
	return current_mode == Mode.HUB
