class_name TestEnemy extends CharacterBody3D

var player : Player
var speed  : float = 40
var health : int = 2

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	SignalBus.enemy_spawned.emit(self)
	#SignalBus.ping_enemies.connect(ping_player)

func _physics_process(delta: float) -> void:
	var direction : Vector3 = (player.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * speed * delta
	look_at(player.global_transform.origin, Vector3.UP)
	move_and_slide()
	
func ping_player() -> void:
	#SignalBus.enemy_spawned.emit(self)
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		queue_free()

func damage_enemy() -> void:
	health -= 1
	if health <= 0:
		queue_free()
