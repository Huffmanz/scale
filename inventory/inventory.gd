extends PanelContainer

const slot = preload("res://inventory/slot.tscn")
@onready var item_grid = $MarginContainer/ItemGrid
const weapon_placeholder = preload("res://assets/Free-TDS-Game-UI-Pixel-Art/HUD/WEAPON ICONS/Pistol HUD.png")
const ammo_placeholder = preload("res://assets/Free-TDS-Game-UI-Pixel-Art/HUD/CHARACTER HUD/Ammo Icon.png")

func set_inventory_data(inventory_data: InventoryData) -> void:
	if not inventory_data.inventory_updated.is_connected(populate_item_grid):
		inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)
	
func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var new_slot = slot.instantiate()
		item_grid.add_child(new_slot)
		new_slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		if slot_data:
			new_slot.set_slot_data(slot_data)
		if inventory_data is InventoryDataWeapon:
			new_slot.place_holder.texture = weapon_placeholder
		if inventory_data is InventoryDataAmmo:
			var weapon: ItemDataWeapon = PlayerManager.player.weapon_inventory_data.slot_datas[0].item_data
			new_slot.place_holder.texture = weapon.ammo_placeholder
