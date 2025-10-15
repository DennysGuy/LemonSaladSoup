class_name TitleCard extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

	
func _ready() -> void:
	animation_player.play("fade_in")


func go_to_main() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/Main.tscn")


func play_lemon_line() -> void:
	AudioManager.play_sfx(AudioManager.HOLDER_VOX_TITLE_LEMON)

func play_salad_line() -> void:
	AudioManager.play_sfx(AudioManager.HOLDER_VOX_TITLE_SALAD)

func play_soup_line() -> void:
	AudioManager.play_sfx(AudioManager.HOLDER_VOX_TITLE_SOUP)
