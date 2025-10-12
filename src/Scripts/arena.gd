class_name Arena extends Node3D


@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_points: Node = $SpawnPoints
@onready var enemies: Node = $Enemies

@onready var spawn_point_2: SpawnPoint = $SpawnPoints/SpawnPoint2
@onready var animation_player: AnimationPlayer = $AnimationPlayer


enum SPAWN_POINT_DIR{ADJACENT,FORWARD}

var spawn_time : int = 8

func _ready() -> void:
	SignalBus.start_wave.connect(start_spawn_timer)
	SignalBus.stop_wave.connect(end_wave)
	SignalBus.set_wave_params.connect(init_wave_spawn_time)
	SignalBus.decrement_spawn_time.connect(decrement_spawn_time)
	SignalBus.spawn_single_enemy_in_front.connect(spawn_greeter_at_point_2)
	SignalBus.make_boss_fall.connect(make_boss_fall)
	SignalBus.make_boss_jump.connect(make_boss_jump)

func _on_spawn_timer_timeout() -> void:
	var enemy : Enemy = WaveManager.get_weighted_enemy().instantiate()
	var chosen_spawn_point : SpawnPoint = spawn_points.get_children().pick_random()
	var offset : Vector3 
	match chosen_spawn_point.direction:
		SPAWN_POINT_DIR.ADJACENT:
			offset = Vector3(randi_range(0,-1),0,randi_range(-5,5))
			if enemy is ShooterEnemy:
				enemy.is_adjacent = true
		SPAWN_POINT_DIR.FORWARD:
			offset = Vector3(randi_range(-5,5),0,randi_range(0,-1))
		
	enemy.global_transform.origin = chosen_spawn_point.global_transform.origin + offset
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

func make_boss_jump() -> void:
	animation_player.play("BossJumps")

func make_boss_fall() -> void:
	animation_player.play("BossFalls")


func boss_fall_shake() -> void:
	SignalBus.shake_camera.emit(3)

func clear_enemies() -> void:
	for enemy in enemies.get_children():
		enemy.queue_free()

func spawn_greeter_at_point_2():
	var greeter : WalkerEnemy = preload("uid://coiyr773xvwd4").instantiate()
	
	greeter.is_greeter = true
	greeter.global_transform.origin = spawn_point_2.global_transform.origin
	enemies.add_child(greeter)
