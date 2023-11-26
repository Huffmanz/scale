extends InventoryData
class_name InventoryDataAmmo

var current_weapon: ItemDataWeapon
var reload_stream = preload("res://assets/audio/Snake's Authentic Gun Sounds/Reloads, Cycling & More/WAV/Single Shot Reload Part 1 WAV.wav")
func _init():
	GameEvents.weapon_changed.connect(on_weapon_changed)
	
func on_weapon_changed(new_weapon):
	current_weapon = new_weapon

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	if not grabbed_slot_data.item_data is ItemDataAmmo:
		return grabbed_slot_data
		
	if not current_weapon.ammo.name == grabbed_slot_data.item_data.name:
		return grabbed_slot_data
		
	if slot_datas[index] and current_weapon.load_individual:
		return grabbed_slot_data
	RandomAudioStreamPlayer.play_single(reload_stream)
	if current_weapon.load_individual:
	#if len(current_weapon.ammo_inventory.slot_datas) > 1:
		return super.drop_single_slot_data(grabbed_slot_data, index)	
	else:
		return super.drop_slot_data(grabbed_slot_data, index)
	
	

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	if not grabbed_slot_data.item_data is ItemDataAmmo || not current_weapon.ammo.name == grabbed_slot_data.item_data.name:
		return grabbed_slot_data
	return super.drop_single_slot_data(grabbed_slot_data, index)
