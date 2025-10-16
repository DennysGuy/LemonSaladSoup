class_name MainMenu extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer


func _ready() -> void:
	AudioManager.play_music(AudioManager.START_MENU_THEME_OPTION_1)


func _on_play_button_button_up() -> void:
	AudioManager.stop_music_player()
	AudioManager.play_sfx(AudioManager.UI_GAME_START_01)
	animation_player.play("fade_out")

func go_to_title_card() -> void:
	#video_stream_player.stop()
	var scene_path = "res://src/Scenes/LemonSaladSoupTitleCard.tscn"
	var scene_res = load(scene_path)
	
	if scene_res == null:
		print("❌ Failed to load:", scene_path)
	else:
		print("✅ Loaded:", scene_path)
		call_deferred("_do_scene_change", scene_res)


func _do_scene_change(scene_res: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene_res)


func _on_play_button_mouse_entered() -> void:
	AudioManager.play_sfx(AudioManager.UI_HOVER_01)
