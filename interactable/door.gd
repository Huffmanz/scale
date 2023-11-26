extends StaticBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var light_occluder_2d = $LightOccluder2D
@onready var random_audio_stream_player = $RandomAudioStreamPlayer

var opened = false
func open():
	if opened:
		return
	animated_sprite_2d.play("open")
	random_audio_stream_player.play_random()
	await animated_sprite_2d.animation_finished
	if not opened:
		opened = true
		collision_shape_2d.queue_free()
		light_occluder_2d.queue_free()
