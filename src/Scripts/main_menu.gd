class_name MainMenu extends Control


func _ready() -> void:
	AudioManager.play_music(AudioManager.START_MENU_THEME_OPTION_1)


func _on_play_button_button_up() -> void:
	AudioManager.stop_music_player()
	get_tree().change_scene_to_file("res://src/Scenes/Main.tscn")
