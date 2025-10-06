class_name Player extends CharacterBody3D

@export var look_at_point_1 : Marker3D
@export var look_at_point_2 : Marker3D
@export var look_at_point_3 : Marker3D
@export var look_at_point_4 : Marker3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera

var rotate_speed: float = 5.0  # higher = faster turn
var target_location : Marker3D
var zoom_target: float = 60.0  # smaller FOV = zoom in
var zoom_speed: float = 5.0    # how fast zoom eases

var initial_player_rotation = Vector3.ZERO
var initial_head_rotation = Vector3.ZERO
var initial_fov: float

var target_index : int = 1

@onready var look_at_positions : Array[Marker3D] = [look_at_point_3, look_at_point_1, look_at_point_2, look_at_point_4]


func _ready() -> void:
	target_location = look_at_positions[target_index]
	
	initial_player_rotation = rotation
	initial_head_rotation = head.rotation
	initial_fov = camera.fov
	
func _process(delta : float) -> void:
	if Input.is_action_just_pressed("rotate_left"):
		#print("hello")
		target_index -= 1
		
		if target_index < 0:
			target_index = 3
		print(target_index)
		target_location = look_at_positions[target_index]
	
	if Input.is_action_just_pressed("rotate_right"):
		#print("bye")
		target_index += 1
		
		if target_index > look_at_positions.size()-1:
			target_index = 0
			
		print(target_index)
		target_location = look_at_positions[target_index]
	
	if Input.is_action_just_pressed("rotate_opposite"):
		if target_index == look_at_positions.size()-1:
			target_index = 1
		elif target_index == 0:
			target_index = 2
		else:
			target_index += 2
			if target_index == look_at_positions.size():
				target_index = 0
				
		print(target_index)
		target_location = look_at_positions[target_index]
func _physics_process(delta: float) -> void:
	move_camera(delta)
	
	
func look_at_target(target : Marker3D, zoom : float) -> void:
	zoom_target = zoom
	target_location = target
	

func move_camera(_delta : float) -> void:
	if target_location:
		var target_pos = target_location.global_transform.origin
		var my_pos = global_transform.origin

		# --- Smooth yaw (player rotation) ---
		var to_target = (target_pos - my_pos).normalized()
		to_target.y = 0.0
		var target_yaw = atan2(-to_target.x, -to_target.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, _delta * rotate_speed)

		# --- Smooth pitch (head/camera tilt) ---
		var head_to_target = (target_pos - head.global_transform.origin).normalized()
		var target_pitch = -asin(head_to_target.y)
		head.rotation.x = lerp_angle(head.rotation.x, target_pitch, _delta * rotate_speed)

		# --- Smooth zoom ---
		camera.fov = lerp(camera.fov, zoom_target, _delta * zoom_speed)
	else:
		# Ease back out to normal FOV when not facing
		rotation.y = lerp_angle(rotation.y, initial_player_rotation.y, _delta * rotate_speed)
		head.rotation.x = lerp_angle(head.rotation.x, initial_head_rotation.x, _delta * rotate_speed)
		camera.fov = lerp(camera.fov, initial_fov, _delta * zoom_speed)
