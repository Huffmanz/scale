extends Node

@export var velocity_component: VelocityComponent
@export var max_weight: float
@export var curve: Curve
@onready var random_stream_player = $RandomStreamPlayer

var current_weight: float = 0.0
var current_equipped_weight: float = 0.0
var starting_speed: float

func _ready():
	GameEvents.inventory_changed.connect(on_inventory_changed)
	starting_speed = velocity_component.max_speed
	
func on_inventory_changed(inventory_data: InventoryData):
	if inventory_data is InventoryDataWeapon:
		current_equipped_weight = inventory_data.get_total_weight()
	else:
		current_weight = inventory_data.get_total_weight()
	var total_weight = current_equipped_weight + current_weight
	var current_weight_ratio = 1 - (total_weight / max_weight)
	var percent_reduction = 1 - curve.sample(current_weight_ratio)
	velocity_component.max_speed = starting_speed * percent_reduction
	if(1 - percent_reduction > .5):
		random_stream_player.play_random()
	else:
		random_stream_player.stop()
	GameEvents.emit_player_weight_changed(percent_reduction)

