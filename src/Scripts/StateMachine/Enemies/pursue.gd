class_name Pursue extends State


func enter() -> void:
	parent.animation_player.play("walk")
	#parent.animation_player.play(animation_name)
	pass

func exit() -> void:
	pass


func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	var direction : Vector3 = (parent.player.global_transform.origin - parent.global_transform.origin).normalized()
	parent.velocity = direction * parent.speed * _delta
	parent.look_at(parent.player.global_transform.origin, Vector3.UP)
	parent.move_and_slide()
	
	return null
