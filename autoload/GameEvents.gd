extends Node


signal toggle_inventory
signal weapon_changed(weapon_data: ItemDataWeapon)
signal inventory_changed(inventory_data: InventoryData)
signal player_weight_changed(weight_percent: float)
signal player_health_changed(current_health: int, max_health: int)
signal camera_shake(camera_shake_strength: float)
signal weapon_fire()
signal hide_player()

func emit_toggle_inventory():
	toggle_inventory.emit()
	
func emit_weapon_changed(weapon_data:ItemDataWeapon):
	weapon_changed.emit(weapon_data)
	
func emit_inventory_changed(inventory_data: InventoryData):
	inventory_changed.emit(inventory_data)
	
func emit_player_weight_changed(weight_percent: float):
	player_weight_changed.emit(weight_percent)
	
func emit_player_health_changed(current: int, max: int):
	player_health_changed.emit(current, max)
	
func emit_camera_shake(camera_shake_strength: float):
	camera_shake.emit(camera_shake_strength)
	
func emit_weapon_fire():
	weapon_fire.emit()
	
func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
	
