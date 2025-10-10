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
