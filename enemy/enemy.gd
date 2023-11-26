extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox = $Hurtbox
@onready var hitbox = $Hitbox
@onready var attack_timer = $attack_timer
@onready var attack_radius = $AttackRadius
@onready var hurt_audio_player = $HurtAudioPlayer
@onready var nav_agent = $NavigationAgent2D
@onready var groan_stream_player: RandomStreamPlayer = $GroanStreamPlayer
@onready var player_detector = $PlayerDetector

var direction: Vector2
var dead = false
var attacking = false
var found_player = false

func _ready():
	health_component.died.connect(on_died)
	hitbox.area_entered.connect(on_hitbox_area_entered)
	attack_timer.timeout.connect(on_attack_timer_timeout)
	attack_radius.area_entered.connect(on_attack_radius_entered)
	health_component.health_decreased.connect(on_health_decreased)
	nav_agent.velocity_computed.connect(on_velocity_computed)
	player_detector.body_entered.connect(on_player_detector_entered)
	player_detector.body_exited.connect(on_player_detector_exited)
	hitbox.set_deferred("monitorable", false) 
	hitbox.set_deferred("monitoring", false)

func _physics_process(delta):
	if dead or attacking or not found_player:
		return
	var player: Node2D = get_tree().get_first_node_in_group("Player")	
	var currentLocation =  global_position
	nav_agent.target_position = player.global_position
	var next_location = Vector2.ZERO
	if nav_agent.is_target_reachable():
		next_location = nav_agent.get_next_path_position()
		direction = (next_location - currentLocation).normalized()
		nav_agent.set_velocity(velocity_component.accelerate_in_direction(direction))
		if not groan_stream_player.playing:
			groan_stream_player.play_random()
	#direction = global_position.direction_to(next_location).normalized()
	if direction == Vector2.ZERO:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk_right")
	
	flip()
	
func on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
	
func flip():
	var move_sign = sign(direction.x)
	if(move_sign != 0):
		animated_sprite_2d.scale = Vector2(move_sign, 1)
		attack_radius.scale = Vector2(move_sign, 1)
		hitbox.scale = Vector2(move_sign, 1)
		
func on_died():
	dead = true
	animated_sprite_2d.play("die")
	hurtbox.queue_free()
	attack_radius.queue_free()
	hitbox.queue_free()
	nav_agent.queue_free()
	
func on_attack_radius_entered(other_area):
	attacking = true
	animated_sprite_2d.play("attack")
	hitbox.set_deferred("monitorable", true) 
	hitbox.set_deferred("monitoring", true)
	await animated_sprite_2d.animation_finished
	attack_timer.start()
	attacking = false
	
func on_hitbox_area_entered(other_area):
	attack_radius.set_deferred("monitorable", false) 
	attack_radius.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false) 
	hitbox.set_deferred("monitoring", false)	
	
func on_attack_timer_timeout():
	if not attack_radius: 
		return
	attack_radius.set_deferred("monitorable", true) 
	attack_radius.set_deferred("monitoring", true)

func on_health_decreased():
	hurt_audio_player.play_random()
	
func on_player_detector_entered(other_body):
	found_player = true
	
func on_player_detector_exited(other_body):
	found_player = false
