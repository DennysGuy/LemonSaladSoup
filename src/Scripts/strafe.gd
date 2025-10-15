class_name Strafe extends State

@export var strafe_time :float = 1.5
@export var shoot_state : State
var strafe_dir : String
var direction : Vector3
@onready var movement_timer: Timer = $"../../MovementTimer"
func enter() -> void:
	print("HEY!!! STRAFE NOE!!!")
	parent.animation_player.play("walk")
	movement_timer.wait_time = randi_range(1,2)
	movement_timer.start()
	if strafe_dir == "left":
		strafe_dir = "right"
	else:
		strafe_dir = "left"
	
	if parent.is_adjacent:
		if strafe_dir == "left": 	
			direction = Vector3(0,0,-1) 
		elif strafe_dir == "right": 
			direction = Vector3(0,0,1)
		
	else:
		if strafe_dir == "left":
			direction = Vector3(-1,0,0) 
		elif strafe_dir == "right": 
			direction = Vector3(1,0,0)
	
func exit() -> void:
	pass


func process_frame(_delta: float) -> State:
	

	
	return null

func process_physics(_delta: float) -> State:
	
	if movement_timer.time_left <= 0.0:
		return shoot_state
	
	parent.velocity = direction * parent.move_speed * 4 * _delta
	parent.look_at(parent.player.global_transform.origin, Vector3.UP)
	parent.move_and_slide()
	
	return null
