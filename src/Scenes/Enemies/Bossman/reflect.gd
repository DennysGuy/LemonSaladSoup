class_name Reflect extends State


func enter() -> void:
	parent.force_field_player.play("react")
	await get_tree().create_timer(0.5).timeout
	parent.state_machine.change_state(parent.prev_state)
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
