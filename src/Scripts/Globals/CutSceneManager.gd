extends Node


func _ready() -> void:
	SignalBus.piss_off_boss.connect(play_fight_commencement_scene)

func look_at_boss_man():
	SignalBus.look_at_point.emit("point 5")

func look_at_point_6():
	SignalBus.look_at_point.emit("point 6")

func look_at_point_1():
	SignalBus.look_at_point.emit("point 1")

func look_at_point_2():
	SignalBus.look_at_point.emit("point 2")
	
func look_at_point_3():
	SignalBus.look_at_point.emit("point 3")

func look_at_point_4():
	SignalBus.look_at_point.emit("point 1")

func zoom_camera() -> void:
	SignalBus.zoom_camera.emit(30)

func spawn_greeter() -> void:
	SignalBus.spawn_single_enemy_in_front.emit()

func reset_camera_fov() -> void:
	SignalBus.reset_camera_fov.emit()

func enable_player_movement() -> void:
	SignalBus.enable_movement.emit()
	SignalBus.show_gun.emit()

func make_boss_jump() -> void:
	SignalBus.make_boss_jump.emit()

func make_boss_fall() -> void:
	SignalBus.make_boss_fall.emit()

func disable_player_movement() -> void:
	SignalBus.disable_movement.emit()
	SignalBus.hide_gun.emit()

func play_intro_cutscene() -> void:
	Dialogic.start("intro")

func show_boss_hp() -> void:
	SignalBus.show_boss_hp.emit()

func shake_camera() -> void:
	SignalBus.shake_camera.emit(2.0)

func play_fight_commencement_scene() -> void:
	Dialogic.start("Fight_Commencement")

func disable_force_field() -> void:
	SignalBus.disable_force_field.emit()

func show_hude() -> void:
	SignalBus.show_hud.emit()
