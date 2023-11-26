extends Resource
class_name InventoryData

@export var slot_datas: Array[SlotData]
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal inventory_updated(inventory_data: InventoryData)

func on_slot_clicked(index:int, button:int) -> void:
	inventory_interact.emit(self, index, button)

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else: 
		return null
		
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	var return_slot_data: SlotData
	if slot_datas[index] and slot_datas[index].can_fully_merge_with(grabbed_slot_data) and slot_data.item_data.can_fully_merge(grabbed_slot_data.item_data,slot_data.quantity, grabbed_slot_data.quantity):
	#if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	inventory_updated.emit(self)
	return return_slot_data
	
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	else:
		if slot_data.can_merge_with(grabbed_slot_data) and slot_data.item_data.can_fully_merge(grabbed_slot_data.item_data,slot_data.quantity, 1):
			slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
			
	inventory_updated.emit(self)
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else :
		return null

func pick_up_slot_data(slot_data) -> bool:
	for index in slot_datas.size():
		var inv_slot_data = slot_datas[index]
		if not inv_slot_data:
			continue
		var new_quantity = slot_data.quantity + slot_datas[index].quantity
		if inv_slot_data.can_fully_merge_with(slot_data) and inv_slot_data.item_data.can_fully_merge(slot_data.item_data,inv_slot_data.quantity, slot_data.quantity):
		#if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data) and new_quantity <= slot_data.item_data.max_stack_size and slot_data.item_data.stackable:
		#if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)
			inventory_updated.emit(self)
			return true
			
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	return false

func remove_all_slot_data():
	for i in range(len(slot_datas)):
		if slot_datas[i]:
			slot_datas[i] = null
	inventory_updated.emit(self)
	
func remove_single_slot_data(index):
	var slot_data = slot_datas[index]
	if not slot_data:
		return
		
	if slot_data.item_data is ItemDataAmmo:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
		inventory_updated.emit(self)
	
func use_slot_data(index) -> void:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		return
	if slot_data.item_data is ItemDataConsumable:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
			
	PlayerManager.use_slot_data(slot_data)
	inventory_updated.emit(self)
	
func get_total_weight() -> int:
	var total_weight = 0.0
	for slot_data in slot_datas:
		if slot_data:
			total_weight +=  slot_data.item_data.weight * slot_data.quantity
	return total_weight

