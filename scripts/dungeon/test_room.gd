extends Node2D

## Salle de test jouable du Milestone 1.
## Elle vérifie mouvement, facing, dash, attaque melee et health/damage avant l'ajout des ennemis.

@onready var player: Node = %Player
@onready var health_label: Label = %HealthLabel
@onready var currency_label: Label = %CurrencyLabel
@onready var return_hub_button: Button = %ReturnHubButton

var run_currency: int = 0


## Connecte le joueur et les contrôles UI de test.
func _ready() -> void:
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	return_hub_button.pressed.connect(_on_return_hub_pressed)
	_connect_enemies()
	_on_player_health_changed(player.health_component.current_health, player.health_component.max_health)
	_update_currency_label()


## Met à jour l'affichage de vie du joueur.
func _on_player_health_changed(current_health: int, max_health: int) -> void:
	health_label.text = "Health: %d / %d" % [current_health, max_health]


## Connecte les ennemis présents dans la salle au joueur et au système de drops.
func _connect_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_method("set_target"):
			enemy.set_target(player)
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)


## Ajoute la currency de run lâchée par un ennemi mort.
func _on_enemy_died(_enemy: Node, currency_value: int) -> void:
	run_currency += currency_value
	_update_currency_label()


## Met à jour l'affichage de currency gagnée pendant la run de test.
func _update_currency_label() -> void:
	currency_label.text = "Run gears: %d" % run_currency


## Simule la boucle roguelite minimale: à la mort, retour au hub.
func _on_player_died() -> void:
	SignalBus.run_ended.emit("player_death")
	SceneLoader.go_to_hub()


## Permet de quitter manuellement la salle de test sans mourir.
func _on_return_hub_pressed() -> void:
	SignalBus.run_ended.emit("manual_return")
	SceneLoader.go_to_hub()
