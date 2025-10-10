class_name Arena extends Node3D


@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_points: Node = $SpawnPoints
@onready var enemies: Node = $Enemies

var spawn_time : int = 8

func _ready() -> void:
	SignalBus.start_wave.connect(start_spawn_timer)
	SignalBus.stop_wave.connect(end_wave)
	SignalBus.set_wave_params.connect(init_wave_spawn_time)
	SignalBus.decrement_spawn_time.connect(decrement_spawn_time)

func _on_spawn_timer_timeout() -> void:
	var enemy : TestEnemy = preload("uid://coiyr773xvwd4").instantiate()
	var chosen_spawn_point : Marker3D = spawn_points.get_children().pick_random()
	enemy.global_transform.origin = chosen_spawn_point.global_transform.origin
	enemies.add_child(enemy)
	
	var random_time : float = max(0.3, randi_range(spawn_time-2, spawn_time))
	spawn_timer.wait_time = random_time
	#SignalBus.enemy_spawned.emit(enemy)

func set_spawn_time(new_spawn_time : float) -> void:
	spawn_timer.wait_time = new_spawn_time

func init_wave_spawn_time() -> void:
	var wave = WaveManager.waves[WaveManager.current_wave]
	spawn_time = wave["spawn_time"]
	spawn_timer.wait_time = spawn_time

func stop_spawn_timer() -> void:
	spawn_timer.wait_time = 0
	spawn_timer.stop()

func adjust_spawn_time(value : int) -> void:
	spawn_time += value

#call this at some point in the round
func decrement_spawn_time() -> void:
	adjust_spawn_time(-1)

func start_spawn_timer() -> void:
	spawn_timer.start()

func end_wave() -> void:
	stop_spawn_timer()
	clear_enemies()

func clear_enemies() -> void:
	for enemy in enemies.get_children():
		enemy.queue_free()
