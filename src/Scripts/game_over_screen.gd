class_name GameOverScreen extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	animation_player.play("FadeIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_button_up() -> void:
	audio_stream_player.stop()
	SignalBus.make_boss_laugh.emit()
	GameManager.waves_reset = true
	AudioManager.play_sfx(AudioManager.VOX_BOSS_LAUGH_02)
	AudioManager.play_sfx(AudioManager.START_MENU_THEME_OPTION_1,-2)
	animation_player.play("fade_out")
	GameManager.reset_game()
	WaveManager.reset()

func go_to_main() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/Main.tscn")
