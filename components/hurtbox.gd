extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent
var blood = preload("res://effects/blood.tscn")
func _ready():
	area_entered.connect(on_area_entered)
	
func on_area_entered(other_area:Area2D):
	if not other_area is HitboxComponent:
		return
		
	if health_component == null:
		return	
		
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	var new_blood = blood.instantiate()
	new_blood.global_position = global_position
	new_blood.rotation = PlayerManager.player.global_position.angle_to_point(global_position)
	get_tree().current_scene.add_child(new_blood)
	GameEvents.frameFreeze(0.1, 0.3)
