extends CharacterBody2D
class_name Bullet

@export var ammo_data: ItemDataAmmo
@onready var hitbox: HitboxComponent = $Hitbox
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var sprite_2d = $Sprite2D

var fmj = false

var impact_effect = preload("res://effects/bullet_impact.tscn")

func _ready():
	hitbox.area_entered.connect(on_area_entered)
	hitbox.body_entered.connect(on_body_entered)
	
func setup(new_ammo_data:ItemDataAmmo, new_fmj: bool = false, new_damage: int = 1):
	ammo_data = new_ammo_data
	fmj = new_fmj
	hitbox.damage = new_damage
		
func _physics_process(delta):
	velocity = velocity_component.accelerate_in_direction(global_transform.x)
	move_and_slide()
	
func on_area_entered(other_area:Node2D):
	if not other_area is HurtboxComponent:
		return 
	if fmj: 
		return
	set_physics_process(false)
	sprite_2d.visible = false
	queue_free()
	
func on_body_entered(other_body):
	var new_impact = impact_effect.instantiate()
	new_impact.global_position = global_position
	new_impact.rotation = global_position.angle_to_point(PlayerManager.player.global_position)
	get_tree().current_scene.add_child(new_impact)
	queue_free()
	

