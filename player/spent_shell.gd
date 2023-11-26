extends Node2D

@onready var bounce_component: BounceComponent = $BounceComponent

var direction = Vector2.UP

func _ready():
	bounce_component.start()
	bounce_component.tween_completed.connect(on_tween_finished)
	direction.x = randf_range(-10, 10)
	direction.y = randf_range(10, 20)
	
func _physics_process(delta):
	global_position += direction * delta
	
func on_tween_finished():
	set_physics_process(false)
