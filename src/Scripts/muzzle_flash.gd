class_name MuzzleFlash extends Node3D


func _ready() -> void:
	var random_size : float = randf_range(1.0,1.3)
	scale = Vector3(random_size,random_size,random_size)
