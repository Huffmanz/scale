extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable:bool = false
@export var texture:AtlasTexture
@export var weight: float = 0.0
@export var max_stack_size: int = 99


func use(target) -> void:
	pass

func can_fully_merge(item_data: ItemData, value1: int, value2:int) -> bool:
	return item_data.name == name and value1 + value2 <= max_stack_size and stackable
