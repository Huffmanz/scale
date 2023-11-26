extends Node2D
class_name ItemSpawnerComponent

@export var inventory_data: InventoryData
@export var marker: Marker2D

var pickup = preload("res://item/pickup/pickup.tscn")

func spawn_items():
	var slot_datas = inventory_data.slot_datas
	var player:CharacterBody2D = PlayerManager.player
	for i in len(slot_datas):
		if slot_datas[i]:
			var new_pickup: RigidBody2D = pickup.instantiate()
			get_tree().current_scene.add_child(new_pickup)
			new_pickup.setup(slot_datas[i])
			var direction = (player.global_position - marker.global_position).normalized()
			new_pickup.global_position = marker.global_position + (direction * Vector2(randf_range(10.0, 20.0), randf_range(10.0, 20.0)))
			await get_tree().create_timer(.5).timeout
