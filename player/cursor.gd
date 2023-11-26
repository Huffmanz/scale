extends Sprite2D

var placeholder: Texture = preload("res://assets/Cursors/Outline/crosshair001.png")
var show = true
@onready var animation_player = $AnimationPlayer


func _ready():
	GameEvents.weapon_changed.connect(on_weapon_changed)
	GameEvents.toggle_inventory.connect(on_inventory_toggled)
	GameEvents.weapon_fire.connect(on_weapon_fire)
	texture = placeholder
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	global_position = get_global_mouse_position()

func on_weapon_changed(weapon: ItemDataWeapon):
	if weapon:
		texture = weapon.cross_hair
	else:
		texture = placeholder

func on_inventory_toggled():
	show = !show
	visible = show
	if show:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_weapon_fire():
	animation_player.play("fire")
