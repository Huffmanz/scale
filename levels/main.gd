extends Node2D

const Pickup = preload("res://item/pickup/pickup.tscn")
var player: CharacterBody2D
@onready var inventory_interface = $UI/InventoryInterface
@onready var hotbar_inventory = $UI/HotbarInventory
var pause_menu_scene = preload("res://UI/pause_menu.tscn")

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	GameEvents.weapon_changed.connect(on_player_weapon_changed)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_weapon_inventory_data(player.weapon_inventory_data)
	inventory_interface.drop_slot_data.connect(on_drop_slot_data)
	GameEvents.toggle_inventory.connect(toggle_inventory_interface)
	
	hotbar_inventory.set_inventory_data(player.inventory_data)
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)	
	
func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = !inventory_interface.visible
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		hotbar_inventory.hide()
	else:
		hotbar_inventory.show()
		
		
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()
		
	PlayerManager.busy = inventory_interface.visible
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()	
		
func on_drop_slot_data(slot_data: SlotData):
	var pick_up = Pickup.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)
	
func on_player_weapon_changed(weapon_data: ItemDataWeapon):
	if weapon_data:
		inventory_interface.set_ammo_inventory_data(player.weapon.weapon_data.ammo_inventory)
	else:
		inventory_interface.clear_ammo_inventory_data()
