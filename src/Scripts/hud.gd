class_name HUD extends CanvasLayer

@onready var marker_2d: Marker2D = $Marker2D
@onready var black_bars_player: AnimationPlayer = $"../BlackBarsPlayer"
@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.add_rifle_preview.connect(add_rifle_unlock_overlay)
	SignalBus.remove_rifle_preview.connect(remove_rifle_unlock_overlay)
	SignalBus.show_black_bars.connect(show_black_bars)
	SignalBus.hide_black_bars.connect(hide_black_bars)
	progress_bar.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_game"):
		progress_bar.show()
		progress_bar.value += 0.8
		if progress_bar.value >= progress_bar.max_value:
			GameManager.reset_game(true)
			WaveManager.current_wave = -1
			GameManager.waves_reset = true
			AudioManager.stop_music_player()
			get_tree().reload_current_scene()
			
	else:
		progress_bar.value = 0
		progress_bar.hide()


func show_black_bars() -> void:
	black_bars_player.play("show_bars")

func hide_black_bars() -> void:
	black_bars_player.play("hide_bars")

func add_rifle_unlock_overlay() -> void:
	var rifle_preview : RiflePreview = preload("uid://c4mt18ooxip2a").instantiate()
	add_child(rifle_preview)


func remove_rifle_unlock_overlay() -> void:
	var preview = get_tree().get_first_node_in_group("RiflePreview")
	preview.queue_free()
