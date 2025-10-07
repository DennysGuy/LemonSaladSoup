class_name Player extends CharacterBody3D

@export var look_at_point_1 : Marker3D
@export var look_at_point_2 : Marker3D
@export var look_at_point_3 : Marker3D
@export var look_at_point_4 : Marker3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var gun_arm: Node3D = $Head/GunArm

@onready var reticle: TextureRect = $Crosshair/Reticle
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var reticle_offset := Vector2(-90,0)
const SENSITIVITY := 0.4
var rotate_speed: float = 5.0  # higher = faster turn
var target_location : Marker3D
var zoom_target: float = 60.0  # smaller FOV = zoom in
var zoom_speed: float = 5.0    # how fast zoom eases

var initial_player_rotation = Vector3.ZERO
var initial_head_rotation = Vector3.ZERO
var initial_fov: float
@onready var ray_cast_3d: RayCast3D = $RayCast3D

var target_index : int = 1

var mouse_visibilty_toggled : bool = false

@onready var detector_1: Area3D = $Detector1
@onready var detector_2: Area3D = $Detector2
@onready var detector_3: Area3D = $Detector3

@onready var alert_silencer: Area3D = $Head/AlertSilencer


@onready var look_at_positions : Array[Marker3D] = [look_at_point_3, look_at_point_1, look_at_point_2, look_at_point_4]

@export var aim_box_size: Vector2 = Vector2(200, 200) # how far the reticle can drift from center

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	target_location = look_at_positions[target_index]
	
	initial_player_rotation = rotation
	initial_head_rotation = head.rotation
	initial_fov = camera.fov

@export var max_arm_offset: Vector2 = Vector2(600, 300) # how far the arm can move on screen

func _process(delta: float) -> void:
	var screen_center = get_viewport().get_visible_rect().size * 0.5
	var mouse_pos = screen_center + reticle_offset
	# Move the crosshair UI anywhere on the screen
	reticle.position = mouse_pos
	
	# Calculate gun arm target (clamped)
	var screen_offset = mouse_pos - screen_center
	var clamped_offset = Vector2(
		clamp(screen_offset.x, -max_arm_offset.x, max_arm_offset.x),
		clamp(screen_offset.y, -max_arm_offset.y, max_arm_offset.y)
	)
	var arm_screen_pos = screen_center + clamped_offset

	# Build ray from camera through clamped arm position
	var from = camera.project_ray_origin(arm_screen_pos)
	var to = from + camera.project_ray_normal(arm_screen_pos) * 1000

	# Make the gun arm look at clamped target
	gun_arm.look_at(to, Vector3.UP)
	var x_rot = clamp(gun_arm.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	gun_arm.rotation = Vector3(x_rot, gun_arm.rotation.y, gun_arm.rotation.z)
	
	if Input.is_action_just_pressed("rotate_left"):
		alert_silencer.get_child(0).disabled = true
		timer.start()
		#print("hello")
		target_index -= 1
		
		if target_index < 0:
			target_index = 3
		print(target_index)
		target_location = look_at_positions[target_index]
	
	if Input.is_action_just_pressed("rotate_right"):
		alert_silencer.get_child(0).disabled = true
		timer.start()
		#print("bye")
		target_index += 1
		
		if target_index > look_at_positions.size()-1:
			target_index = 0
			
		print(target_index)
		target_location = look_at_positions[target_index]
	
	if Input.is_action_just_pressed("rotate_opposite"):
		alert_silencer.get_child(0).disabled = true
		timer.start()
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
	
	if Input.is_action_just_pressed("exit"):
		
		mouse_visibilty_toggled = !mouse_visibilty_toggled
		
		if mouse_visibilty_toggled:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		animation_player.play("shoot_pistol")
		shoot_ray()
	
	if event is InputEventMouseMotion:
		# Move virtual reticle with mouse delta
		reticle_offset += event.relative * SENSITIVITY

func get_aim_ray() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	return to


func shoot_ray() -> Node3D:
	var mouse_pos = reticle.position
	var ray_length = 10
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = camera.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	var collided_object
	if raycast_result:
		collided_object = raycast_result["collider"]
	print(collided_object)
	return collided_object

	
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


func _on_detector_1_body_entered(body: Node3D) -> void:
	print("A mf entered on the left side!")
	SignalBus.alert_player.emit(detector_1)


func _on_detector_2_body_entered(body: Node3D) -> void:
	print("A mf entered on the right side!")
	SignalBus.alert_player.emit(detector_2)

func _on_detector_3_body_entered(body: Node3D) -> void:
	print("A mf entered on the back!")
	SignalBus.alert_player.emit(detector_3)


func _on_alert_silencer_area_entered(area) -> void:
	print("WOWWWWW")
	if area is EnemyDetectorDetector:
		var enemy_detector : EnemyDetectorDetector = area
		print("I've seen you: " + str(area))
		SignalBus.silence_alarm.emit(area.detector_area)
		area.detector_area = null


func _on_timer_timeout() -> void:
	alert_silencer.get_child(0).disabled = false
