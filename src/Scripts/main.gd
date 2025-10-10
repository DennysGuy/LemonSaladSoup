class_name Main extends Node3D

@onready var wave_timer_label: WaveTimerLabel = $HUD/WaveTimerLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var score_label: Label = $HUD/ScoreLabel
@onready var kill_quota_label: Label = $HUD/KillQuotaLabel
@onready var score_count: Label = $HUD/ScoreCount
@onready var kill_count: Label = $HUD/KillCount

@onready var reload_notification: Label = $HUD/ReloadNotification

@onready var bullets: HBoxContainer = $HUD/Magazine/Bullets

var should_blink = true
var blinking = false

var kill_quota : int = 0
var current_kill_count : int = 0
@onready var timer: Timer = $Timer

@onready var magazine_reload_animation_player: AnimationPlayer = $MagazineReloadAnimationPlayer
@onready var health: HBoxContainer = $HUD/Health



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_notification.hide()
	SignalBus.init_count_down.connect(init_count_down)
	SignalBus.stop_wave.connect(stop_wave)
	SignalBus.increment_kill_count.connect(update_kill_count)
	SignalBus.update_score_label.connect(update_score)
	SignalBus.show_reload_notification.connect(show_reload_notification)
	SignalBus.update_ammo_count.connect(update_ammo_count)
	SignalBus.reload_pistol.connect(play_reload_animation)
	SignalBus.start_invincibility_overlay.connect(start_invincibility_overlay)
	SignalBus.update_health_display.connect(update_health)
	SignalBus.play_death_fadeout.connect(play_game_over_fade)
	update_health()
	update_score()
	init_count_down()
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	kill_quota = waves[current_wave]["kill_quota"]
	current_kill_count = 0
	kill_count.text = "%s/%s" % [current_kill_count,kill_quota]
	
	wave_timer_label.show()
	score_count.show()
	score_label.show()
	kill_quota_label.show()
	kill_count.show()
	SignalBus.set_wave_params.emit()

func start_wave() -> void:
	WaveManager.wave_started = true
	SignalBus.start_wave.emit()

func update_kill_count() -> void:
	current_kill_count += 1
	kill_count.text = "%s/%s" % [current_kill_count,kill_quota]
	if current_kill_count >= kill_quota:
		wave_timer_label.stop_timer()

func stop_wave() -> void:
	score_count.hide()
	score_label.hide()
	kill_quota_label.hide()
	kill_count.hide()
	
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
		
func transition_to_game_over_screen() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/Menus/GameOverScreen.tscn")
