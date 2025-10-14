class_name RIFLE_PREVIEW extends CharacterBody3D

var player : Player

@onready var avtomat: Node3D = $Avtomat
var move_speed : int = 300

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	avtomat.rotation.y += 0.2

	if not GameManager.rifle_unlocked:
		var direction : Vector3 = (player.magnet_point.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * move_speed * delta
		look_at(player.global_transform.origin, Vector3.UP)
		move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		GameManager.rifle_unlocked = true
		SignalBus.swap_to_rifle_first_time.emit()
		queue_free()
