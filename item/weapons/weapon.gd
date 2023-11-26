extends Node2D
class_name Weapon

@export var weapon_data: ItemDataWeapon
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var marker_2d = $Sprite2D/Marker2D
@onready var shot_timer = $ShotTimer
@onready var shell = $Sprite2D/Marker2D/Shell
@onready var shot_audio_player = $ShotAudioPlayer
@onready var dry_fire_player = $DryFirePlayer

var spend_shell = preload("res://player/spent_shell.tscn")
var bullet = preload("res://player/bullet.tscn")
#var can_shoot = false
var can_aim = true
func _ready():
	can_aim = true
	if weapon_data:
		update_weapon(weapon_data)
	GameEvents.toggle_inventory.connect(on_inventory_toggle)
	sprite_2d.flip_h = true
	#shot_timer.timeout.connect(on_shot_timer_timeout)

func on_inventory_toggle():
	can_aim = !can_aim

func _process(delta):
	if !can_aim: 
		return
	move(get_global_mouse_position() - global_position)

#func on_shot_timer_timeout():
	#can_shoot = check_ammo()

func check_ammo() -> bool:
	if not shot_timer.is_stopped():
		return false
		
	if not weapon_data:
		return false
		
	var slot_datas = weapon_data.ammo_inventory.slot_datas
	for i in len(slot_datas):
		if slot_datas[i]:
			return true
	if !dry_fire_player.playing:
		dry_fire_player.play_random()
	return false

func update_weapon(new_weapon_data: ItemDataWeapon = null):
	weapon_data = new_weapon_data
	if new_weapon_data:
		sprite_2d.texture = weapon_data.texture
		shot_timer.wait_time = weapon_data.seconds_between_shots
	else:
		sprite_2d.texture = null
	
func fire():
	if not weapon_data:
		return
	var can_shoot = check_ammo()
	if not can_shoot:
		return
	shot_audio_player.play_random()
	GameEvents.emit_camera_shake(weapon_data.camera_shake_strength)
	#can_shoot = false
	shot_timer.start()
	animation_player.play("fire")
	GameEvents.emit_weapon_fire()
	var new_shell = spend_shell.instantiate()
	get_tree().current_scene.add_child(new_shell)
	new_shell.global_position = shell.global_position
	var slot_datas = weapon_data.ammo_inventory.slot_datas
	for i in len(slot_datas):
		if slot_datas[i]:
			var num_shots = weapon_data.shots
			var angle = 0.0
			for shot in range(num_shots):
				var bullet_instance: CharacterBody2D = bullet.instantiate()
				get_tree().current_scene.add_child(bullet_instance)
				bullet_instance.global_position = marker_2d.global_position
				bullet_instance.rotation_degrees = rotation_degrees + rad_to_deg(angle)
				bullet_instance.setup(weapon_data.ammo, weapon_data.fmj, weapon_data.damage)
				if angle == 0:
					angle = weapon_data.shot_spread
				else:
					angle = -sign(angle) * (shot * weapon_data.shot_spread)
			weapon_data.ammo_inventory.remove_single_slot_data(i)
			return
	
func move(mouse_direction: Vector2) -> void:
	if animation_player.is_playing():
		return
	rotation = mouse_direction.angle()
	if scale.y == 1 and mouse_direction.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouse_direction.x > 0:
		scale.y = 1
		
func is_busy() -> bool:
	return animation_player.is_playing()
