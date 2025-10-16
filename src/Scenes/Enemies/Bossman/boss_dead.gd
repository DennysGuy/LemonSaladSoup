class_name BossDead extends State

func enter() -> void:
	AudioManager.stop_music_player()
	GameManager.stop_total_timer()
	SignalBus.end_game.emit()
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
		
