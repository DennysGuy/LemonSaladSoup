class_name RiflePreviewHUD extends Node3D

@onready var marker_3d: Marker3D = $Marker3D


@onready var avtomat: Node3D = $Avtomat

func _physics_process(delta: float) -> void:
	marker_3d.global_rotation.y += 0.02
