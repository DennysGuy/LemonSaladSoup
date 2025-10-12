extends Node


@warning_ignore("unused_signal")
signal alert_player(area : Area3D)
@warning_ignore("unused_signal")
signal silence_alarm
@warning_ignore("unused_signal")
signal enemy_spawned(enemy : Node3D)
@warning_ignore("unused_signal")
signal ping_enemies

@warning_ignore("unused_signal")
signal start_wave
@warning_ignore("unused_signal")
signal stop_wave

@warning_ignore("unused_signal")
signal set_wave_params
@warning_ignore("unused_signal")
signal set_spawn_time
@warning_ignore("unused_signal")
signal init_count_down

@warning_ignore("unused_signal")
signal increment_kill_count

@warning_ignore("unused_signal")
signal decrement_spawn_time

@warning_ignore("unused_signal")
signal update_score_label

@warning_ignore("unused_signal")
signal update_ammo_count

@warning_ignore("unused_signal")
signal show_reload_notification

@warning_ignore("unused_signal")
signal reload_pistol

@warning_ignore("unused_signal")
signal enable_movement

@warning_ignore("unused_signal")
signal disable_movement
@warning_ignore("unused_signal")
signal enable_shooting

@warning_ignore("unused_signal")
signal shake_camera(shake_time : float)

@warning_ignore("unused_signal")
signal start_invincibility_overlay

@warning_ignore("unused_signal")
signal update_health_display
@warning_ignore("unused_signal")
signal play_death_fadeout

#combo stuff
@warning_ignore("unused_signal")
signal show_added_score_label(added_amount : int, head_shot : bool)
@warning_ignore("unused_signal")
signal show_grade_phrase(grade : int)
@warning_ignore("unused_signal")
signal show_combo_meter
@warning_ignore("unused_signal")
signal remove_one_kill
@warning_ignore("unused_signal")
signal reset_combo_meter
@warning_ignore("unused_signal")
signal decrement_wave_time(value : int)

@warning_ignore("unused_signal")
signal swap_to_pistol
@warning_ignore("unused_signal")
signal swap_to_rifle

@warning_ignore("unused_signal")
signal update_rifle_ammo

#cut scenestuff
@warning_ignore("unused_signal")
signal look_at_boss(point : Marker3D)
@warning_ignore("unused_signal")
signal zoom_camera(fov : float)
@warning_ignore("unused_signal")
signal reset_camera_fov
@warning_ignore("unused_signal")
signal spawn_single_enemy_in_front
@warning_ignore("unused_signal")
signal slow_enemies_motion(speed : float)
@warning_ignore("unused_signal")
signal return_enemies_to_normal_speed
@warning_ignore("unused_signal")
signal look_at_point(point : String)
@warning_ignore("unused_signal")
signal piss_off_boss

@warning_ignore("unused_signal")
signal initialize_countdown
@warning_ignore("unused_signal")
signal show_gun
@warning_ignore("unused_signal")
signal hide_gun
@warning_ignore("unused_signal")
signal make_boss_jump
@warning_ignore("unused_signal")
signal make_boss_fall
