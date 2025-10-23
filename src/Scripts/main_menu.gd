class_name MainMenu extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var scoring_guide_margin_container: MarginContainer = $ScoringGuideMarginContainer


func _ready() -> void:
	scoring_guide_margin_container.hide()
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


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.waves_reset = true
	else:
		GameManager.waves_reset = false


func _on_scoring_guide_toggle_button_down() -> void:
	scoring_guide_margin_container.show()


func _on_button_button_down() -> void:
	scoring_guide_margin_container.hide()
