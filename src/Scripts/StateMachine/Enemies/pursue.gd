class_name Pursue extends State

const CHANCE_TO_BE_SASSY : int = 30

func enter() -> void:
	var random_num : int = randi_range(0,100)
	parent.animation_player.speed_scale = 0.8
	if random_num <= CHANCE_TO_BE_SASSY and not parent.is_greeter:
		parent.animation_player.play("walk 2 (sassy)")
		parent.move_speed += 20
	else:
		if parent.is_greeter:
			parent.move_speed = 10
		parent.animation_player.play("walk")

func exit() -> void:
	pass


func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	var direction : Vector3 = (parent.player.global_transform.origin - parent.global_transform.origin).normalized()
	parent.velocity = direction * parent.move_speed * _delta
	parent.look_at(parent.player.global_transform.origin, Vector3.UP)
	parent.move_and_slide()
	
	return null
