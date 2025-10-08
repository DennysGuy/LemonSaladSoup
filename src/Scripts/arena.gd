class_name Arena extends Node3D


@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_points: Node = $SpawnPoints
@onready var enemies: Node = $Enemies
func _ready() -> void:
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	var enemy : TestEnemy = preload("uid://coiyr773xvwd4").instantiate()
	var chosen_spawn_point : Marker3D = spawn_points.get_children().pick_random()
	enemy.global_transform.origin = chosen_spawn_point.global_transform.origin
	print("enemy spawned!")
	enemies.add_child(enemy)
	#SignalBus.enemy_spawned.emit(enemy)
