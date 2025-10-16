class_name GameOverScreen extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	animation_player.play("FadeIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_button_up() -> void:
	SignalBus.make_boss_laugh.emit()
	GameManager.waves_reset = true
	animation_player.play("fade_out")
	GameManager.reset_game()
	WaveManager.reset()

func go_to_main() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/Main.tscn")
