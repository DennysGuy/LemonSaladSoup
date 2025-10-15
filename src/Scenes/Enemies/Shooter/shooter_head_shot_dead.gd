class_name BossHeadShotDead extends State

@onready var collision_shape_3d: CollisionShape3D = $"../../HeadCollider/CollisionShape3D"
@onready var collision_shape_3d_body: CollisionShape3D = $"../../BodyCollider/CollisionShape3D"
@onready var parent_collider: CollisionShape3D = $"../../CollisionShape3D"

func enter() -> void:
	collision_shape_3d.disabled = true
	collision_shape_3d_body.disabled = true
	parent_collider.disabled = true
	#parent.animation_player.play(animation_name)
	parent.animation_player.play("HEADSHOTdeath")
	parent.timer.wait_time = 2.0
	parent.timer.start()
	if not GameManager.rifle_unlocked:
		parent.spawn_rifle_drop()
		GameManager.rifle_unlocked = true
	else:
		parent.spawn_ammo_drop()

func exit() -> void:
	pass

var timer : Timer

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		if parent is WalkerEnemy and parent.is_greeter:
			SignalBus.piss_off_boss.emit()
		parent.queue_free()
	
	return null
