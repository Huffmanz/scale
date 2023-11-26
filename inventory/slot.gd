extends PanelContainer

signal slot_clicked(index:int, button:int)
@onready var texture_rect = $MarginContainer/TextureRect
@onready var quantity_label = $%QuantityLabel
@onready var place_holder = $MarginContainer/PlaceHolder
@onready var weight_label = $%WeightLabel

func _ready():
	gui_input.connect(on_guid_input)
	
func set_slot_data(slot_data: SlotData) -> void:
	place_holder.visible = false
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	#tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	var weight = round(slot_data.quantity * slot_data.item_data.weight) as int
	weight_label.visible = slot_data.quantity > 0 && weight >= 1
	weight_label.text = str(weight)
	#if weight >= 1:
	if slot_data.quantity > 1: 
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.show()
	else:
		quantity_label.hide()
		
func on_guid_input(event: InputEvent):
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
