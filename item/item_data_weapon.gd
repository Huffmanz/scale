extends ItemData
class_name ItemDataWeapon

@export var camera_shake_strength: float = 0
@export var seconds_between_shots: float = .5
@export var damage: int = 1
@export var fmj: bool = false
@export var cross_hair: Texture = preload("res://assets/Cursors/Outline/crosshair007.png")
@export var ammo_placeholder: Texture = preload("res://assets/Free-TDS-Game-UI-Pixel-Art/ammo.png")
@export var ammo_inventory: InventoryDataAmmo
@export var ammo: ItemDataAmmo
@export var shots: int = 1
@export var load_individual: bool = false
@export var shot_spread: float = 0.0
@export var scene: PackedScene
