extends CanvasLayer


var how_to_play = preload("res://levels/how_to_play.tscn")

func _ready():
	$%PlayButton.pressed.connect(on_play_pressed)
	$%HowToPlay.pressed.connect(on_how_to_play_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func on_play_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://levels/test_level.tscn")

func on_how_to_play_pressed():
	var instance = how_to_play.instantiate()
	add_child(instance)
	instance.back_pressed.connect(on_how_to_play_closed.bind(instance))
	
	
func on_how_to_play_closed(instance: Node):
	instance.queue_free()
	
func on_quit_pressed():
	get_tree().quit()

