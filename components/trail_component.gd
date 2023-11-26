extends Line2D

var point
@export var target: Node2D
@export var trailLength = 0

func _process(delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	point = target.global_position
	add_point(point)
	while get_point_count() > trailLength:
		remove_point(0)
