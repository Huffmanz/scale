extends Area2D
class_name Interactable

signal interact()

@export var sprite_2d: Sprite2D
@onready var outline_component = $OutlineComponent
@onready var label = $Label

var original_material

func _ready():
	label.hide()
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	if sprite_2d:
		outline_component.sprite = sprite_2d
		original_material = sprite_2d.material

func on_body_entered(other_body):
	outline_component.apply_outline()
	label.show()
	
func on_body_exited(other_body):
	label.hide()
	if sprite_2d:
		sprite_2d.material = original_material
	
func Interact() -> void:
	interact.emit()
	label.hide()

