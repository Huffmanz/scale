extends Node2D

@export var interactables: Array[Node2D]
@onready var interactable_component: Interactable = $InteractableComponent
@onready var random_stream_player = $RandomStreamPlayer

func _ready():
	interactable_component.interact.connect(on_interact)
	
	
func on_interact():
	random_stream_player.play_random()
	for interactable in interactables:
		if interactable.has_method("open"):
			interactable.open()
	interactable_component.queue_free()
