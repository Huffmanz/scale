extends StaticBody2D

@onready var interactable_component:Interactable = $InteractableComponent
@onready var animation_player = $AnimationPlayer

func _ready():
	interactable_component.interact.connect(on_interact)

func on_interact():
	GameEvents.hide_player.emit()
	animation_player.play("down")
	await animation_player.animation_finished
	ScreenTransition.transition_to_scene("res://levels/credits.tscn")
