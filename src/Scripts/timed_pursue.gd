class_name TimedPursue extends State
@export var movement_time : float = 2
@export var strafe_state : State
@onready var movement_timer: Timer = $"../../MovementTimer"

func enter() -> void:
	parent.animation_player.play("walk")
	movement_timer.wait_time = movement_time
	movement_timer.start()
func exit() -> void:
	pass


func process_frame(_delta: float) -> State:
	
	if movement_timer.time_left <= 0.0:
		return strafe_state
	
	return null

func process_physics(_delta: float) -> State:
	
	
	
	var direction : Vector3 = (parent.player.global_transform.origin - parent.global_transform.origin).normalized()
	parent.velocity = direction * parent.move_speed * _delta
	parent.look_at(parent.player.global_transform.origin, Vector3.UP)
	parent.move_and_slide()
	
	return null
