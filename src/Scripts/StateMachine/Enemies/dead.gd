class_name Dead extends State

@onready var collision_shape_3d: CollisionShape3D = $"../../HeadCollider/CollisionShape3D"
@onready var collision_shape_3d_body: CollisionShape3D = $"../../BodyCollider/CollisionShape3D"
@onready var parent_collider: CollisionShape3D = $"../../CollisionShape3D"

func enter() -> void:
	
	collision_shape_3d.disabled = true
	collision_shape_3d_body.disabled = true
	parent_collider.disabled = true
	#parent.animation_player.play(animation_name)
	parent.animation_player.play("die")
	
	if parent is WalkerEnemy and parent.is_greeter:
		AudioManager.play_sfx(AudioManager.CROWD_GASP)
		AudioManager.stop_music_player()
	
	if GameManager.player_current_health < GameManager.PLAYER_MAX_HEALTH:
		parent.spawn_health_drop()
	
	parent.timer.wait_time = 1.8
	parent.timer.start()

func exit() -> void:
	pass

var timer : Timer

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		if parent is WalkerEnemy and parent.is_greeter:
			SignalBus.piss_off_boss.emit()
		parent.remove()
	
	return null
