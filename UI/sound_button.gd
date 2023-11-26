extends Button

@onready var random_audio_stream_player = $RandomAudioStreamPlayer
@onready var hover_animation_player = $HoverAnimationPlayer

func _ready():
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	pivot_offset.x = size.x / 2
	pivot_offset.y = size.y / 2
	
func on_pressed():
	random_audio_stream_player.play_random()
	scale.x = 1
	scale.y = 1
	
func on_mouse_entered():
	hover_animation_player.play("hover")
	random_audio_stream_player.play_random()
	scale.x = 1.1
	scale.y = 1.1 
	
func on_mouse_exited():
	scale.x = 1
	scale.y = 1
