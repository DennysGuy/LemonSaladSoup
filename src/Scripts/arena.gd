class_name Arena extends Node3D


@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_points: Node = $SpawnPoints
@onready var enemies: Node = $Enemies

@onready var spawn_point_2: SpawnPoint = $SpawnPoint2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var enemy_configurations: EnemyConfigurations = $EnemyConfigurations


@onready var boss_animation_player: AnimationPlayer = $BossMan/boss/AnimationPlayer

enum SPAWN_POINT_DIR{ADJACENT,FORWARD}

@onready var config_spawn_point_1: SpawnPoint = $SpawnPoints/SpawnPoint1
@onready var config_spawn_point_2: SpawnPoint = $SpawnPoints/SpawnPoint2
@onready var config_spawn_point_3: SpawnPoint = $SpawnPoints/SpawnPoint3
@onready var config_spawn_point_4: SpawnPoint = $SpawnPoints/SpawnPoint4


var spawn_time : int = 8
var max_config_amount : int = 1

@onready var available_spawn_points : Array = [
	{"spawn point": config_spawn_point_1, "occupied": false },
	{"spawn point": config_spawn_point_2, "occupied": false},
	{"spawn point": config_spawn_point_3, "occupied": false},
	{"spawn point": config_spawn_point_4, "occupied": false}
]

func _ready() -> void:
	SignalBus.start_wave.connect(start_spawn_timer)
	SignalBus.stop_wave.connect(end_wave)
	SignalBus.set_wave_params.connect(init_wave_spawn_time)
	SignalBus.decrement_spawn_time.connect(decrement_spawn_time)
	SignalBus.spawn_single_enemy_in_front.connect(spawn_greeter_at_point_2)
	SignalBus.make_boss_fall.connect(make_boss_fall)
	SignalBus.make_boss_jump.connect(make_boss_jump)
	spawn_timer.one_shot = true

func _process(delta: float) -> void:
	if not WaveManager.wave_started:
		if not enemy_configurations.get_children().is_empty():
			clear_enemies()
			
func _on_spawn_timer_timeout() -> void:
	spawn_timer.stop()
	if WaveManager.wave_started:
		reset_spawn_point_availability()
	
		#this bit of code forces a config containing a shooter so the player can unlock rifle (beginning of round 2)
		if WaveManager.current_wave == 1 and not GameManager.rifle_unlocked:
			var chosen_config_amount : int = 1
			enemy_configurations.config_to_destroy_count = chosen_config_amount
			var chosen_configuration : EnemyConfiguration = preload("uid://j1bah2o4tpc3").instantiate()
			var chosen_spawn_point :SpawnPoint = available_spawn_points[0]["spawn point"]
			chosen_configuration.global_transform.origin = chosen_spawn_point.global_transform.origin
			chosen_configuration.rotation = chosen_spawn_point.rotation
			enemy_configurations.add_child(chosen_configuration)
		else:
			var chosen_config_amount : int = randi_range(1, GameManager.max_config_amount)
			enemy_configurations.config_to_destroy_count = chosen_config_amount
		
			for i in range(chosen_config_amount):
				# Pick a random configuration
				var config_list : Array = WaveManager.waves[WaveManager.current_wave]["config list"]
				var random_config : PackedScene = config_list.pick_random()
				var chosen_configuration : EnemyConfiguration = random_config.instantiate()
				
				# Pick a free spawn point
				var chosen_spawn_point : Dictionary = {}
				while true:
					var candidate = available_spawn_points.pick_random()
					if not candidate["occupied"]:
						chosen_spawn_point = candidate
						break
				
				# Mark spawn point as occupied
				chosen_spawn_point["occupied"] = true
				
				#check if configuration contains shooter
				for enemy in chosen_configuration.enemies.get_children():
					if enemy is ShooterEnemy:
						match chosen_spawn_point["spawn point"].direction:
							SPAWN_POINT_DIR.ADJACENT:
								enemy.is_adjacent = true
							SPAWN_POINT_DIR.FORWARD:
								enemy.is_adjacent = false
				
				# Position and rotate
				chosen_configuration.global_transform.origin = chosen_spawn_point["spawn point"].global_transform.origin
				chosen_configuration.rotation = chosen_spawn_point["spawn point"].rotation
			
				# Add to scene
				enemy_configurations.add_child(chosen_configuration)
				
			if chosen_config_amount >= 2:
				var stagger_time : float = WaveManager.waves[WaveManager.current_wave]["stagger_time"]
				await get_tree().create_timer(randf_range(stagger_time-0.2,stagger_time+0.2)).timeout
		
	
	# Randomize timer AFTER loop
	var random_time : float = randf_range(spawn_time - 0.5, spawn_time + 0.5)
	spawn_timer.wait_time = random_time


func reset_spawn_point_availability() -> void:
	for point in available_spawn_points:
		point["occupied"] = false

func set_spawn_time(new_spawn_time : float) -> void:
	spawn_timer.wait_time = new_spawn_time

func init_wave_spawn_time() -> void:
	var wave = WaveManager.waves[WaveManager.current_wave]
	spawn_time = wave["spawn_time"]
	GameManager.max_config_amount = wave["starting config amount"]
	set_spawn_time(spawn_time)

func stop_spawn_timer() -> void:
	spawn_timer.wait_time = 0
	spawn_timer.stop()

func adjust_spawn_time(value : int) -> void:
	spawn_time += value

#call this at some point in the round
func decrement_spawn_time() -> void:
	adjust_spawn_time(-1)

func start_spawn_timer() -> void:
	if spawn_timer.is_stopped():
		spawn_timer.start()

func end_wave() -> void:
	stop_spawn_timer()
	clear_enemies()

func make_boss_jump() -> void:
	animation_player.play("BossJump")

func make_boss_fall() -> void:
	animation_player.play("BossFall")

func play_boss_idle() -> void:
	boss_animation_player.play("justchillin")

func boss_fall_shake() -> void:
	SignalBus.shake_camera.emit(3)

func clear_enemies() -> void:
	for config in enemy_configurations.get_children():
		config.queue_free()

func spawn_greeter_at_point_2():
	var greeter : WalkerEnemy = preload("uid://coiyr773xvwd4").instantiate()
	
	greeter.is_greeter = true
	greeter.global_transform.origin = spawn_point_2.global_transform.origin
	add_child(greeter)
