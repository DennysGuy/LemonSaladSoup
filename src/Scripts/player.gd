extends CharacterBody3D
class_name Player 


@export var look_at_point_1 : Marker3D
@export var look_at_point_2 : Marker3D
@export var look_at_point_3 : Marker3D
@export var look_at_point_4 : Marker3D
@export var look_at_point_5 : Marker3D

@onready var alert_arrow_left: TextureRect = $Crosshair/AlertArrow
@onready var alert_arrow_right: TextureRect = $Crosshair/AlertArrow2
@onready var alert_arrow_back: TextureRect = $Crosshair/AlertArrow3
@onready var alert_arrow_front: TextureRect = $Crosshair/AlertArrow4

#@onready var gun_2: Node3D = $Head/GUN2
@onready var pistol: Pistol = $Head/Pistol




@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var gun_arm: Node3D = $Head/GunArm

@onready var reticle: TextureRect = $Crosshair/Reticle
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var gun_animation_player: AnimationPlayer = $Head/Pistol/Gun/GUN2/AnimationPlayer

@onready var ar_animation_player: AnimationPlayer = $Head/Pistol/AR/AnimationPlayer


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
var shooting : bool = false
var can_be_hit : bool = true
var mouse_visibilty_toggled : bool = false

@onready var invincibility_timer: Timer = $InvincibilityTimer

@onready var detector_1: Area3D = $Detector1
@onready var detector_2: Area3D = $Detector2
@onready var detector_3: Area3D = $Detector3

#@onready var direction_teller: Label = $Crosshair/DirectionTeller

@onready var look_at_positions : Array[Marker3D] = [look_at_point_3, look_at_point_1, look_at_point_2, look_at_point_4]

@export var aim_box_size: Vector2 = Vector2(200, 200) # how far the reticle can drift from center

@export var enemies_root : Node

func _ready() -> void:
	#direction_teller.hide()
	hide_reticle()
	SignalBus.enemy_spawned.connect(notify_enemy)
	SignalBus.start_wave.connect(start_wave)
	SignalBus.stop_wave.connect(stop_wave)
	SignalBus.enable_movement.connect(enable_movement)
	SignalBus.disable_movement.connect(disable_movement)
	SignalBus.enable_shooting.connect(enable_shooting)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	target_location = look_at_positions[target_index]
	
	initial_player_rotation = rotation
	initial_head_rotation = head.rotation
	initial_fov = camera.fov
@onready var muzzle: Marker3D = $Muzzle

@export var max_arm_offset: Vector2 = Vector2(600, 300) # how far the arm can move on screen

func _process(delta: float) -> void:
	#print(GameManager.can_shoot)
	_update_arrows()
	if GameManager.can_move:
		
		match GameManager.equipped_weapon:
			GameManager.WEAPONS.PISTOL:
				if Input.is_action_just_pressed("shoot") and GameManager.can_shoot:
					disable_shooting()
					var collided_object = shoot_ray()
					shoot_enemy(collided_object)
					play_shoot_animation()
			GameManager.WEAPONS.RIFLE:
				if Input.is_action_pressed("shoot") and GameManager.can_shoot and not shooting:
					shooting = true
					play_rifle_shoot_animation()
		
				
		move_arm()
		move_player()

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("exit"):
		pause_game()
	
	
		
	if event is InputEventMouseMotion:
		# Move virtual reticle with mouse delta
		reticle_offset += event.relative * SENSITIVITY

func move_player() -> void:
	if Input.is_action_just_pressed("rotate_left"):
		rotate_camera_left()

	if Input.is_action_just_pressed("rotate_right"):
		rotate_camera_right()
	
	if GameManager.can_shoot:
		if Input.is_action_just_pressed("swap_pistol") and GameManager.equipped_weapon == GameManager.WEAPONS.RIFLE:
			GameManager.equipped_weapon = GameManager.WEAPONS.PISTOL
			animation_player.play("SwapWeapons")
			SignalBus.swap_to_pistol.emit()
		
		if Input.is_action_just_pressed("swap_rifle") and GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL and GameManager.rifle_ammo_count > 0:
			GameManager.equipped_weapon = GameManager.WEAPONS.RIFLE
			animation_player.play("SwapWeapons")
			SignalBus.swap_to_rifle.emit()
		
			
	if Input.is_action_just_pressed("reload") and GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL:
		play_reload_animation()
		SignalBus.reload_pistol.emit()
	
	if Input.is_action_just_pressed("rotate_opposite"):
		rotate_camera_opposite()
	

func move_arm() -> void:
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
	pistol.look_at(to, Vector3.UP)
	var x_rot = clamp(pistol.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	pistol.rotation = Vector3(x_rot, pistol.rotation.y, pistol.rotation.z)

func pause_game() -> void:
	mouse_visibilty_toggled = !mouse_visibilty_toggled
		
	if mouse_visibilty_toggled:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func rotate_camera_left() -> void:
	target_index -= 1
		
	if target_index < 0:
		target_index = 3
			
	target_location = look_at_positions[target_index]

func rotate_camera_right() -> void:
	target_index += 1
		
	if target_index > look_at_positions.size()-1:
		target_index = 0
			
	target_location = look_at_positions[target_index]

func rotate_camera_opposite() -> void:
	if target_index == look_at_positions.size()-1:
		target_index = 1
	elif target_index == 0:
		target_index = 2
	else:
		target_index += 2
		if target_index == look_at_positions.size():
			target_index = 0
			
	target_location = look_at_positions[target_index]


func shoot_enemy(enemy_body_part : Node3D):
	if  enemy_body_part and enemy_body_part.get_parent() is Enemy: 
		var seen_enemy : Enemy = enemy_body_part.get_parent()

		if enemy_body_part is EnemyBodyCollider:
			seen_enemy.damage_enemy()
		elif enemy_body_part is EnemyHeadCollider:
			seen_enemy.head_shot_kill()
	
func damage_player() -> void:
	if can_be_hit:
		SignalBus.shake_camera.emit(1.0)
		SignalBus.start_invincibility_overlay.emit()
		GameManager.player_current_health -= 1
		SignalBus.update_health_display.emit()
		SignalBus.reset_combo_meter.emit()
		if GameManager.player_current_health <= 0:
			disable_movement()
			hide_arm()
			hide_reticle()
			SignalBus.play_death_fadeout.emit()
		else:
			invincibility_timer.start()
		
		can_be_hit = false
		#play overlay animation too
			#fade out red and go to game over screen
	
func play_shoot_animation() -> void:
	gun_animation_player.speed_scale = 3.5
	GameManager.ammo_count -= 1
	SignalBus.update_ammo_count.emit()
	gun_animation_player.play("SHOOT")
	
	if GameManager.ammo_count <= 0 and GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL:
		GameManager.can_shoot = false
		SignalBus.show_reload_notification.emit()
	else:
		await get_tree().create_timer(0.2).timeout
		GameManager.can_shoot = true


func play_rifle_shoot_animation() -> void:
	ar_animation_player.speed_scale = 4
	ar_animation_player.play("ArmatureAction")
	var body_part = shoot_ray()
	shoot_enemy(body_part)
	GameManager.rifle_mag_ammo_count -= 1
	
	if GameManager.rifle_mag_ammo_count <= 0 and GameManager.rifle_ammo_count > 0:
		#reload
		if GameManager.rifle_ammo_count >= 10:
			GameManager.rifle_mag_ammo_count = 10
			GameManager.rifle_ammo_count -= 10
		else:
			GameManager.rifle_ammo_count = GameManager.rifle_ammo_count
			GameManager.rifle_ammo_count = 0
	
	SignalBus.update_rifle_ammo.emit()
	
	if GameManager.rifle_ammo_count <= 0 and GameManager.rifle_mag_ammo_count <= 0:
		GameManager.equipped_weapon = GameManager.WEAPONS.PISTOL
		GameManager.ammo_count = GameManager.PISTOL_MAGAZINE_SIZE
		SignalBus.swap_to_pistol.emit()
		animation_player.play("SwapWeapons")
	
	
	await get_tree().create_timer(0.2).timeout
	shooting = false

func play_reload_animation() -> void:
	gun_animation_player.speed_scale = 1.5
	gun_animation_player.play("RELOAD")

func get_aim_ray() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	return to

func shoot_ray() -> Node3D:
	# Use the actual reticle position on screen
	var mouse_pos = reticle.position
	
	# Project a ray from the camera through the reticle
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 9000

	var space = camera.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.exclude = [self]  # prevent hitting player
	ray_query.collision_mask = 1 << 5 # adjust to hit only desired targets

	var result = space.intersect_ray(ray_query)

	if result:
		return result["collider"]
	else:
		print("damned")
		#SignalBus.reset_combo_meter.emit()
	return null
	
func _physics_process(delta: float) -> void:
	move_camera(delta)
	
	
func look_at_target(target : Marker3D, zoom : float) -> void:
	zoom_target = zoom
	target_location = target
	

func move_camera(_delta: float) -> void:
	if target_location:
		var target_pos = target_location.global_transform.origin
		var my_pos = global_transform.origin

		# --- Compute desired yaw to target ---
		var to_target = (target_pos - my_pos).normalized()
		to_target.y = 0.0
		var target_yaw = atan2(-to_target.x, -to_target.z)

		# --- Snap yaw to nearest cardinal direction ---
		var snapped_yaw = round(target_yaw / (PI / 2.0)) * (PI / 2.0)

		# --- Smoothly rotate player to snapped direction with easing ---
		var yaw_diff = wrapf(snapped_yaw - rotation.y, -PI, PI)
		var t = 1.0 - pow(0.5, _delta * rotate_speed)  # smooth exponential easing
		rotation.y += yaw_diff * t

		# Optional: snap instantly if very close to target to avoid tiny jitters
		#if abs(yaw_diff) < deg_to_rad(1.0):
			#rotation.y = snapped_yaw

		# --- Smooth pitch (head tilt) ---
		var head_to_target = (target_pos - head.global_transform.origin).normalized()
		var target_pitch = -asin(head_to_target.y)
		head.rotation.x = lerp_angle(head.rotation.x, target_pitch, _delta * rotate_speed)

		# --- Smooth zoom ---
		camera.fov = lerp(camera.fov, zoom_target, _delta * zoom_speed)
	else:
		# Ease back to initial rotation and FOV when no target
		rotation.y = lerp_angle(rotation.y, initial_player_rotation.y, _delta * rotate_speed)
		head.rotation.x = lerp_angle(head.rotation.x, initial_head_rotation.x, _delta * rotate_speed)
		camera.fov = lerp(camera.fov, initial_fov, _delta * zoom_speed)

var enemy_alerts: Array = [] 

func notify_enemy(enemy: Node3D) -> void:
	#print("Enemy spawned in quadrant: ", _get_enemy_quadrant(enemy))
	#if enemy not in enemy_alerts:
	enemy_alerts.append(enemy)
		
func _get_enemy_quadrant(enemy: Node3D) -> String:
	var to_enemy = (enemy.global_transform.origin - global_transform.origin).normalized()

	# Transform into player's local space
	var local_dir = global_transform.basis.inverse() * to_enemy

	# Get angle of enemy in local XZ plane
	var angle = atan2(local_dir.x, -local_dir.z) # radians, relative to forward (-Z)

	# Snap to quadrant
	if abs(angle) <= PI / 4:
		return "front"
	elif angle > PI / 4 and angle < 3 * PI / 4:
		return "right"
	elif angle < -PI / 4 and angle > -3 * PI / 4:
		return "left"
	else:
		return "back"

func _get_facing_quadrant() -> String:
	var forward = -camera.global_transform.basis.z
	if abs(forward.x) > abs(forward.z):
		return "right" if forward.x > 0 else "left"
	else:
		return "front" if forward.z < 0 else "back"

func _is_facing_quadrant(enemy_quadrant: String) -> bool:
	var forward = -camera.global_transform.basis.z.normalized()

	var local_dir := Vector3.ZERO
	match enemy_quadrant:
		"front": local_dir = Vector3.FORWARD
		"right": local_dir = Vector3.RIGHT
		"back": local_dir = Vector3.BACK
		"left": local_dir = Vector3.LEFT

	# convert local quadrant dir to world space
	var world_dir = global_transform.basis * local_dir
	world_dir = world_dir.normalized()

	# dot product now makes sense: forward (world) vs quadrant (world)
	var dot = forward.dot(world_dir)
	return dot > cos(deg_to_rad(20))  # ~0.94

func _update_arrows() -> void:
	# Hide all arrows at start
	alert_arrow_front.visible = false
	alert_arrow_back.visible = false
	alert_arrow_left.visible = false
	alert_arrow_right.visible = false

	var dir_shown = {"front": false, "back": false, "left": false, "right": false}
	var quadrant_counts = {"front": 0, "back": 0, "left": 0, "right": 0}
	
	#var facing = _get_facing_quadrant()
	
	# Count enemies per quadrant
	for enemy in enemies_root.get_children():
		if not is_instance_valid(enemy) or not enemy.alive:
			enemy_alerts.erase(enemy)
			continue

		var q = _get_enemy_quadrant(enemy)
		#print("Im facing here: " + facing + " Enemy is located here: " + q)
		
		# Remove enemies if player is facing that quadrant
		if _is_facing_quadrant(q):
			#print("but I dropped in here...")
			enemy_alerts.erase(enemy)
			#direction_teller.hide()
			continue

		quadrant_counts[q] += 1

		# Show arrow once per quadrant
		#print(q)
		match q:
			"front": 
				alert_arrow_front.visible = true
			"back": 
				alert_arrow_back.visible = true
			"left": 
				alert_arrow_left.visible = true
			"right": 
				alert_arrow_right.visible = true
	
		dir_shown[q] = true


func hide_arm() -> void:
	animation_player.play("HideArm")


func show_arm() -> void:
	animation_player.play("ShowArm")

func enable_shooting() -> void:
	GameManager.can_shoot =  true

func disable_shooting() -> void:
	GameManager.can_shoot = false

func show_reticle() -> void:
	reticle.show()

func hide_reticle() -> void:
	reticle.hide()

func start_wave() -> void:
	show_arm()

func disable_movement() -> void:
	GameManager.can_move = false
	GameManager.can_shoot = false
	hide_reticle()
	
func enable_movement() -> void:
	GameManager.can_move = true
	GameManager.can_shoot = true
	show_reticle()
	
func stop_wave() -> void:

	disable_movement()
	target_index = 1
	target_location = look_at_positions[target_index]
	hide_arm()


func flash_muzzle() -> void:
	var muzzle_flare = preload("uid://c32dc8g4xyoc3").instantiate()
	muzzle.add_child(muzzle_flare)
	await get_tree().create_timer(0.3).timeout
	muzzle_flare.queue_free()
	


func _on_invincibility_timer_timeout() -> void:
	can_be_hit = true
