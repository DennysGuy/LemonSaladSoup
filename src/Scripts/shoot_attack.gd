class_name ShootAttack extends State

@export var movement_time : float = 2.0
@export var strafe_state : State

func enter() -> void:
	parent.animation_player.play("attack")
	parent.movement_timer.wait_time = movement_time
	parent.movement_timer.start()
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.movement_timer.time_left <= 0.0:
		return strafe_state
	return null
