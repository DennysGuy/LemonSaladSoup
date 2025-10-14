class_name EnemyConfigurations extends Node


var config_to_destroy_count : int = 0
@onready var spawn_timer: Timer = $"../SpawnTimer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.decrement_config_count.connect(decrement_config_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func decrement_config_count() -> void:
	config_to_destroy_count -= 1
	
	if config_to_destroy_count <=0 and WaveManager.wave_started:
		spawn_timer.start()
