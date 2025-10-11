class_name Main extends Node3D

@onready var wave_timer_label: WaveTimerLabel = $HUD/WaveTimerLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var marker_2d: Marker2D = $HUD/Marker2D
@onready var hud: CanvasLayer = $HUD

@onready var score_label: Label = $HUD/ScoreLabel
@onready var kill_quota_label: Label = $HUD/KillQuotaLabel
@onready var score_count: Label = $HUD/ScoreCount
@onready var kill_count: Label = $HUD/KillCount

@onready var reload_notification: Label = $HUD/ReloadNotification

@onready var bullets: HBoxContainer = $HUD/Magazine/Bullets

var should_blink = true
var blinking = false

@onready var combo_meter_animation_player: AnimationPlayer = $ComboMeterAnimationPlayer
@onready var grade_phrase_player: AnimationPlayer = $GradePhrasePlayer


@onready var added_score: Label = $HUD/AddedScore
@onready var grade_phrase: Label = $HUD/GradePhrase

@onready var combo_meter: Control = $HUD/ComboMeter
@onready var kill_count_box: HBoxContainer = $HUD/ComboMeter/KillCount

@onready var combo_count: RichTextLabel = $HUD/ComboMeter/ComboCount

var combo_meter_wait_time : int = 30

@onready var magazine_reload_animation_player: AnimationPlayer = $MagazineReloadAnimationPlayer
@onready var health: HBoxContainer = $HUD/Health

@onready var added_score_label_player: AnimationPlayer = $AddedScoreLabelPlayer

#all things timers
@onready var timer: Timer = $Timer
@onready var added_score_label_timer: Timer = $AddedScoreLabelTimer

var combo_meter_showing : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_notification.hide()
	SignalBus.init_count_down.connect(init_count_down)
	SignalBus.stop_wave.connect(stop_wave)
	SignalBus.update_score_label.connect(update_score)
	
	SignalBus.show_reload_notification.connect(show_reload_notification)
	SignalBus.update_ammo_count.connect(update_ammo_count)
	SignalBus.reload_pistol.connect(play_reload_animation)
	SignalBus.start_invincibility_overlay.connect(start_invincibility_overlay)
	
	SignalBus.update_health_display.connect(update_health)
	SignalBus.play_death_fadeout.connect(play_game_over_fade)
	SignalBus.show_added_score_label.connect(show_added_score_label)
	SignalBus.remove_one_kill.connect(decrement_combo_meter_kill_count)
	SignalBus.reset_combo_meter.connect(reset_combo_meter)
	
	SignalBus.show_grade_phrase.connect(show_grading_phrase)
	
	update_combo_meter_label()
	update_health()
	update_score()
	init_count_down()
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if should_blink and not blinking:
		blinking = true
		reload_notif_blink()

func show_reload_notification() -> void:
	reload_notification.show()

func hide_reload_notification() -> void:
	reload_notification.hide()

func init_count_down() -> void:
	animation_player.play("WaveStartCountDown")

func play_reload_animation() -> void:
	magazine_reload_animation_player.play("reload")

func start_invincibility_overlay() -> void:
	animation_player.play("Invincibility")

func set_wave_parameters() -> void:
	WaveManager.move_to_next_wave()
	var current_wave : int = WaveManager.current_wave
	var waves : Dictionary = WaveManager.waves
	var time : int = waves[current_wave]["time"]
	wave_timer_label.set_time(time)
	
	wave_timer_label.show()
	score_count.show()
	score_label.show()
	SignalBus.set_wave_params.emit()

func start_wave() -> void:
	WaveManager.wave_started = true
	SignalBus.start_wave.emit()

func show_added_score_label(score : int, head_shot : bool) -> void:
	if head_shot:
		added_score.text =  "+%s Head Shot!" % [score]
	else:
		added_score.text = "+%s" % [score]
	added_score_label_player.play("show_added_score")
	added_score_label_timer.start()
	
func stop_wave() -> void:
	score_count.hide()
	score_label.hide()
	
	reset_combo_meter()
	#this maybe where I hand starting the next wave?
	timer.start()
	pass

func _on_timer_timeout() -> void:
	var wave : Dictionary = WaveManager.waves[WaveManager.current_wave]
	if wave["cut_scene"]:
		#play the cut scene -- this will have the init count play at the end
		pass
	else:
		init_count_down()

func update_score() -> void:
	score_count.text = str(GameManager.score)

func play_game_over_fade() -> void:
	animation_player.play("Dead")

func update_ammo_count() -> void:
	clear_box(bullets)
	for i in GameManager.ammo_count:
		var bullet : TextureRect = TextureRect.new()
		bullet.texture = preload("uid://bqq433bs811mc")
		bullets.add_child(bullet)

func reload_pistol() -> void:
	GameManager.ammo_count = GameManager.PISTOL_MAGAZINE_SIZE
	update_ammo_count()

func clear_box(hbox : HBoxContainer) -> void:
	for child in hbox.get_children():
		child.queue_free()

func reload_notif_blink() -> void:
	await get_tree().create_timer(1).timeout
	reload_notification.modulate = Color(1,1,1, 1)
	await get_tree().create_timer(1).timeout
	reload_notification.modulate = Color(1,1,1, 0)
	blinking = false

func update_health() -> void:
	clear_box(health)
	for i in GameManager.player_current_health:
		var soup : TextureRect = TextureRect.new()
		soup.texture = preload("uid://bknkh3ke4u81p")
		health.add_child(soup)
		
@onready var combo_meter_timer: Timer = $ComboMeterTimer

func decrement_combo_meter_kill_count() -> void:
	
	combo_meter_timer.wait_time = combo_meter_wait_time
	combo_meter_timer.start()
	GameManager.kills_left -= 1
	
	if GameManager.kills_left <= 0:
		GameManager.kills_left = GameManager.KILLS_NEEDED
		GameManager.current_multiplier += 1
		if GameManager.current_multiplier == 2:
			combo_meter_showing = true
			combo_meter_animation_player.play("show_combo_meter")
	
	update_combo_meter_label()

func reset_combo_meter() -> void:
	GameManager.current_multiplier = 1
	GameManager.kills_left = 4
	combo_meter_timer.stop()
	combo_meter_timer.wait_time = combo_meter_wait_time
	if combo_meter_showing:
		combo_meter_animation_player.play("hide_combo_meter")

func set_combo_meter_hidden() -> void:
	combo_meter_showing = false

func update_combo_meter_label() -> void:
	combo_count.text = "[font_size=32]combo[/font_size][font_size=52]x%s[/font_size]" % [GameManager.current_multiplier]
	clear_box(kill_count_box)
	for i in GameManager.kills_left:
		var icon : TextureRect = TextureRect.new()
		icon.texture = preload("uid://r2br5ovrur3u")
		kill_count_box.add_child(icon)
	

func transition_to_game_over_screen() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/Menus/GameOverScreen.tscn")


func _on_added_score_label_timer_timeout() -> void:
	added_score_label_player.play("hide_added_score")


func _on_combo_meter_timer_timeout() -> void:
	reset_combo_meter()

func show_grading_phrase(bonus: int) -> void:
	match bonus:
		3:
			grade_phrase.text = "PERFECT!"
		2:
			grade_phrase.text = "GREAT!"
		1:
			grade_phrase.text = "NOT BAD!"
	
	grade_phrase_player.play("show_grade_phrase")
