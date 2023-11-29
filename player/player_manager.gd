extends Node

var player
var busy = false

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)
