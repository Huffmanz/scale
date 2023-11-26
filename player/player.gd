extends CharacterBody2D

@export var inventory_data: InventoryData
@export var weapon_inventory_data: InventoryDataWeapon
@onready var weapon_holder = $WeaponHolder
@onready var weapon: Weapon = $WeaponHolder/Weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var interaction_area: Area2D = $InteractionArea
@onready var velocity_component = $VelocityComponent
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var hit_audio_stream_player = $HitAudioStreamPlayer
@onready var player_death_stream_player = $PlayerDeathStreamPlayer

var interactable: Interactable
var direction = Vector2.ZERO
func _ready():
	PlayerManager.player = self
	GameEvents.player_weight_changed.connect(on_player_weight_changed)
	weapon_inventory_data.inventory_updated.connect(on_weapon_updated)
	inventory_data.inventory_updated.connect(GameEvents.emit_inventory_changed)
	weapon_inventory_data.inventory_updated.connect(GameEvents.emit_inventory_changed)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.died.connect(on_died)
	interaction_area.area_entered.connect(on_interact_enter)
	interaction_area.area_exited.connect(on_interact_exit)
	GameEvents.hide_player.connect(on_hide_player)
	
func _physics_process(delta):
	
	if PlayerManager.busy:
		return
	flip()
	if Input.is_action_pressed("attack"):
		weapon.fire()
	
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	direction = direction.normalized()
	velocity = velocity_component.accelerate_in_direction(direction)
	if direction == Vector2.ZERO:
		animation_player.play("idle")
	else:
		animation_player.play("walk")	
	
	move_and_slide()
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("inventory"):
		GameEvents.emit_toggle_inventory()
	if Input.is_action_just_pressed("interact"):
		interact()
		
func flip():
	var move_sign = sign(direction.x)
	if(move_sign != 0):
		sprite_2d.scale = Vector2(move_sign, 1)
		interaction_area.scale = Vector2(move_sign, 1)
		
	if move_sign == 0:
		move_sign = sign((get_global_mouse_position() - global_position).x)
		if(move_sign != 0):
			sprite_2d.scale = Vector2(move_sign, 1)
			interaction_area.scale = Vector2(move_sign, 1)	

func on_interact_enter(other_area):
	if other_area is Interactable:
		interactable = other_area
	
func on_interact_exit(other_area):
	interactable = null
	
func interact():
	if interactable:
		interactable.Interact()

func get_drop_position() -> Vector2:
	var direction = (get_global_mouse_position() - global_position).normalized() 
	return global_position + direction * 40
	
func heal(heal_amount):
	health_component.heal(heal_amount)
	GameEvents.emit_player_health_changed(health_component.current_health, health_component.max_health)
	
func on_weapon_updated(weapon_data: InventoryDataWeapon):
	if weapon_data.slot_datas[0]:
		weapon.queue_free()
		weapon = weapon_data.slot_datas[0].item_data.scene.instantiate()
		weapon_holder.add_child(weapon)
		weapon.global_position = weapon_holder.global_position
		weapon.update_weapon(weapon_data.slot_datas[0].item_data)
		weapon.can_aim = false
		GameEvents.emit_weapon_changed(weapon_data.slot_datas[0].item_data)
	else:
		weapon.update_weapon()
		GameEvents.emit_weapon_changed(null)

func on_player_weight_changed(weight_percent: float):
	animation_player.speed_scale = weight_percent
	
func on_health_decreased():
	hit_audio_stream_player.play_random()
	GameEvents.emit_camera_shake(5)
	GameEvents.emit_player_health_changed(health_component.current_health, health_component.max_health)

func on_died():
	player_death_stream_player.play_random()
	animation_player.play("death")
	PlayerManager.busy = true
	await player_death_stream_player.finished
	PlayerManager.busy = false
	inventory_data.remove_all_slot_data()
	weapon_inventory_data.remove_all_slot_data()
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
	
func on_hide_player():
	sprite_2d.visible = !sprite_2d.visible
	weapon_holder.visible = !weapon_holder.visible
	$Shadow.visible = !$Shadow.visible
