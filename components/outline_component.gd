extends Node

@export var sprite: Sprite2D
@export var animated_sprite: AnimatedSprite2D
var outline_material = preload("res://shaders/outline_shader_material.tres")


func apply_outline():
	if sprite:
		sprite.material = outline_material
	if animated_sprite:
		animated_sprite.material = outline_material
