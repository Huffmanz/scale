extends StaticBody2D

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData
@onready var interactable_component:Interactable = $InteractableComponent
@onready var item_spawner_component: ItemSpawnerComponent = $ItemSpawnerComponent

func _ready():
	interactable_component.interact.connect(player_interact)
	item_spawner_component.inventory_data = inventory_data
	
func player_interact():
	#toggle_inventory.emit(self)
	item_spawner_component.spawn_items()
	interactable_component.queue_free()
