extends PanelContainer

signal hot_bar_use(index:int)

const slot = preload("res://inventory/slot.tscn")
@onready var h_box_container = $MarginContainer/HBoxContainer

func _unhandled_key_input(event: InputEvent):
	if not visible or not event.is_pressed():
		return
	if range(KEY_1, KEY_7).has(event.keycode):
		hot_bar_use.emit(event.keycode - KEY_1)

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_hotbar)
	populate_hotbar(inventory_data)
	hot_bar_use.connect(inventory_data.use_slot_data)

func populate_hotbar(inventory_data: InventoryData) -> void:
	for child in h_box_container.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas.slice(0,6):
		var new_slot = slot.instantiate()
		h_box_container.add_child(new_slot)
		if slot_data:
			new_slot.set_slot_data(slot_data)
