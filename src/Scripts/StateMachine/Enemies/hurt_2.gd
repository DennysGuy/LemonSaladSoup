class_name Hurt2 extends State

@export var pursue_state : State
@export var attack_state : State

func enter() -> void:
	parent.animation_player.play("hurt2")
	parent.timer.wait_time =  0.8
	parent.timer.start()
	pass

func exit() -> void:
	pass

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	
	if parent.timer.time_left <= 0:
		if parent.player_in_range:
			return attack_state
		
		return pursue_state
	
	
	return null
