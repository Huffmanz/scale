extends CanvasLayer

signal back_pressed
@onready var back_button = %BackButton
@onready var animation_player = $AnimationPlayer

func _ready():
	back_button.pressed.connect(on_back_pressed)
	
	
func on_back_pressed():
	animation_player.play("out")
	await animation_player.animation_finished
	back_pressed.emit()
