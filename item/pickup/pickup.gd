extends RigidBody2D

@export var slot_data: SlotData
@onready var sprite_2d = $Sprite2D
@onready var pickup_area = $PickupArea
@onready var bounce_component: BounceComponent = $BounceComponent
@onready var name_quantity = $NameQuantity

var direction = Vector2.ZERO

func _ready():
	pickup_area.body_entered.connect(on_pickup_body_entered)
	bounce_component.start()
	bounce_component.tween_completed.connect(on_tween_complete)
	direction.x = randf_range(-20, 20)
	direction.y = randf_range(10, 20)
	
	if slot_data:
		setup(slot_data)

func _physics_process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * delta
	
func setup(new_slot_data: SlotData):
	slot_data = new_slot_data
	var item_data = slot_data.item_data
	sprite_2d.texture = slot_data.item_data.texture
	if slot_data.quantity > 1:
		name_quantity.text =  "%s x%s" % [item_data.name, slot_data.quantity]
	else:
		name_quantity.text = item_data.name
	
func on_pickup_body_entered(other_body):
	if other_body.inventory_data.pick_up_slot_data(slot_data):
		queue_free()

func on_tween_complete():
	pickup_area.monitorable = true
	pickup_area.monitoring = true
	direction = Vector2.ZERO
