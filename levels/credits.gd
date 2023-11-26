extends CanvasLayer
@onready var main_menu_button = %MainMenuButton


func _ready():
	main_menu_button.pressed.connect(on_main_menu_pressed)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func on_main_menu_pressed():
	ScreenTransition.transition_to_scene("res://levels/main_menu.tscn")
