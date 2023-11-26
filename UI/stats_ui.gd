extends CanvasLayer

@onready var health_bar = %HealthBar
@onready var weight_bar = %WeightBar


func _ready():
	weight_bar.value = 0
	health_bar.value = 1
	GameEvents.player_health_changed.connect(on_health_changed)
	GameEvents.player_weight_changed.connect(on_weight_changed)

func on_health_changed(current: int, max: int):
	health_bar.value = current as float / max as float

func on_weight_changed(weight_percent):
	weight_bar.value = 1-weight_percent
