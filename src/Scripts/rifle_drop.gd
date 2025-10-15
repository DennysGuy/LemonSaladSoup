class_name RifleDrop extends Node3D

@onready var marker_3d: Marker3D = $Marker3D

var player : Player
var move_to_player : bool = false
var target : Marker3D
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	marker_3d.rotation.y += 0.02
	if move_to_player:
		var target = player.magnet_point.global_position
		var speed = 30.0
		global_position = global_position.move_toward(target, speed * delta)

func _on_timer_timeout() -> void:
	move_to_player = true


func _on_area_3d_area_entered(area: Area3D) -> void:
	Dialogic.start("rifle_unlock_scene")
	queue_free()
