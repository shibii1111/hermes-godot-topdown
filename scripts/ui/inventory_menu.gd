extends Control
class_name InventoryMenu

## Simple inventory overlay for Milestone 3.
## It starts as a 12-slot grid plus equipment placeholders and can later bind to real inventory data.

const SLOT_COUNT := 12

signal close_requested()

@onready var slot_grid: GridContainer = %SlotGrid
@onready var close_button: Button = %CloseButton


## Builds deterministic placeholder slots and hides the menu until requested.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_build_slots()
	close_button.pressed.connect(_on_close_pressed)
	hide_inventory()


## Displays the inventory and focuses the close button for controller navigation.
func show_inventory() -> void:
	visible = true
	close_button.grab_focus()


## Hides the inventory overlay.
func hide_inventory() -> void:
	visible = false


## Toggles inventory visibility without owning pause state.
func toggle_inventory() -> void:
	if visible:
		hide_inventory()
	else:
		show_inventory()


## Creates the temporary 12-slot inventory grid used by Milestone 3.
func _build_slots() -> void:
	if slot_grid.get_child_count() > 0:
		return
	for slot_index in range(SLOT_COUNT):
		var slot := PanelContainer.new()
		slot.name = "Slot%02d" % [slot_index + 1]
		slot.custom_minimum_size = Vector2(64, 64)
		var label := Label.new()
		label.text = "Empty"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slot.add_child(label)
		slot_grid.add_child(slot)


## Handles the close button and notifies the owning room to resume gameplay.
func _on_close_pressed() -> void:
	hide_inventory()
	close_requested.emit()
