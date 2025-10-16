class_name Main extends Node3D

@onready var wave_timer_label: WaveTimerLabel = $HUD/WaveTimerLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var marker_2d: Marker2D = $HUD/Marker2D
@onready var hud: CanvasLayer = $HUD

@onready var score_label: Label = $HUD/ScoreLabel
@onready var kill_quota_label: Label = $HUD/KillQuotaLabel
@onready var score_count: Label = $HUD/ScoreCount
@onready var kill_count: Label = $HUD/KillCount
@onready var rifle_bullets: VBoxContainer = $HUD/RifleMagazine/RifleBullets

@onready var reload_notification: Label = $HUD/ReloadNotification
@onready var grenade_cool_down_label: Label = $HUD/GrenadeIcon/GrenadeCoolDownLabel

@onready var bullets: HBoxContainer = $HUD/Magazine/Bullets
@onready var pick_up_animation_player: AnimationPlayer = $PickUpAnimationPlayer

var should_blink = true
var blinking = false

@onready var boss_hp: ProgressBar = $HUD/BossHP

@onready var combo_meter_animation_player: AnimationPlayer = $ComboMeterAnimationPlayer
@onready var grade_phrase_player: AnimationPlayer = $GradePhrasePlayer
@onready var rifle_mag_reload_animation_player: AnimationPlayer = $RifleMagReloadAnimationPlayer

@onready var texture_progress_bar: TextureProgressBar = $HUD/GrenadeIcon/TextureProgressBar

@onready var added_score: Label = $HUD/AddedScore
@onready var grade_phrase: Label = $HUD/GradePhrase
@onready var final_time_player: AnimationPlayer = $FInalTimePlayer

@onready var combo_meter: Control = $HUD/ComboMeter
@onready var kill_count_box: HBoxContainer = $HUD/ComboMeter/KillCount

@onready var combo_count: RichTextLabel = $HUD/ComboMeter/ComboCount
@onready var combo_meter_timer: Timer = $ComboMeterTimer
@onready var total_timer: Label = $HUD/TotalTimer

@onready var wave_count_down_player: AnimationPlayer = $WaveCountDownPlayer

var combo_meter_wait_time : int = 6
@onready var grenade_cool_down_prog_bar: TextureProgressBar = $HUD/GrenadeIcon/GrenadeCoolDownProgBar

@onready var magazine_reload_animation_player: AnimationPlayer = $MagazineReloadAnimationPlayer
@onready var health: HBoxContainer = $HUD/Health

@onready var added_score_label_player: AnimationPlayer = $AddedScoreLabelPlayer
@onready var wave_title_label: Label = $HUD/WaveTitleLabel

#all things timers
@onready var timer: Timer = $Timer
@onready var added_score_label_timer: Timer = $AddedScoreLabelTimer
@onready var pistol_mag_ammo_label: Label = $HUD/Magazine/PistolMagAmmoLabel
@onready var count_down_label: Label = $HUD/CountDownLabel

var rifle_mag_showing : bool = false
var pistol_mag_showing : bool = true

var combo_meter_showing : bool = false
var grenade_in_cool_down : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combo_meter_timer.wait_time = combo_meter_wait_time
	reload_notification.hide()
	grenade_cool_down_label.hide()
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
	
	SignalBus.swap_to_pistol.connect(swap_to_pistol)
	SignalBus.swap_to_rifle.connect(swap_to_rifle)
	SignalBus.update_rifle_ammo.connect(update_rifle_ammo_count)
	
	SignalBus.initialize_countdown.connect(init_count_down)
	SignalBus.end_game.connect(fade_to_win)
	SignalBus.show_boss_hp.connect(show_boss_hp)
	
	SignalBus.show_hud.connect(show_hud)
	SignalBus.update_boss_hp.connect(update_boss_hp)
	SignalBus.play_health_caught_anim.connect(play_health_caught_anim)
	
	SignalBus.play_ammo_retrieved_flash.connect(play_ammo_pick_up_flash)
	SignalBus.issue_grenade.connect(issue_grenade)
	
	SignalBus.hide_reload_notification.connect(hide_reload_notification)
	
	update_combo_meter_label()
	update_health()
	update_score()
	
	score_count.hide()
	score_label.hide()
	count_down_label.hide()
	#total_timer.hide()
	animation_player.play("fade_in")
	
	if not GameManager.waves_reset:
		CutSceneManager.play_intro_cutscene()
	else:
		init_count_down()
	#init_count_down() #this here is the start of the round we'll replace this with intro cutscene stuff
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if should_blink and not blinking:
		blinking = true
		reload_notif_blink()
	
	if grenade_cooldown_timer.time_left > 0:
		grenade_cool_down_label.text = str(int(grenade_cooldown_timer.time_left))

		

func show_reload_notification() -> void:
	reload_notification.show()

func hide_reload_notification() -> void:
	reload_notification.hide()

func init_count_down() -> void:
	wave_title_label.text = WaveManager.waves[WaveManager.current_wave+1]["wave_title"]
	wave_count_down_player.play("WaveCountDown")

func play_reload_animation() -> void:
	magazine_reload_animation_player.play("reload")

func play_health_caught_anim() -> void:
	pick_up_animation_player.play("Pickups/HealthPickup")
	GameManager.player_current_health += 1
	update_health()
	
func play_ammo_pick_up_flash() -> void:
	pick_up_animation_player.play("Pickups/HealthPickup")

func play_wave_theme() -> void:
	var theme : AudioStream = WaveManager.waves[WaveManager.current_wave]["theme"]
	AudioManager.play_music(theme)
	
func stop_music() -> void:
	AudioManager.stop_music_player()

func start_invincibility_overlay() -> void:
	animation_player.play("Invincibility")

func set_wave_parameters() -> void:
	WaveManager.move_to_next_wave()
	GameManager.ammo_count = GameManager.PISTOL_MAGAZINE_SIZE
	update_ammo_count()
	var current_wave : int = WaveManager.current_wave
	var waves : Dictionary = WaveManager.waves
	var time : int = waves[current_wave]["time"]
	wave_timer_label.set_time(time)

	wave_timer_label.show()
	score_count.show()
	score_label.show()
	SignalBus.set_wave_params.emit()
	
@onready var grenade_icon_player: AnimationPlayer = $GrenadeIconPlayer

func start_wave() -> void:
	WaveManager.wave_started = true
	GameManager.can_throw_grenade = true
	#health shower animation player here
	grenade_icon_player.play("ShowGrenadeIcon")
	added_score_label_player.play("show_health")
	if pistol_mag_showing:
		magazine_reload_animation_player.play("show_mag")
	elif rifle_mag_showing:
		rifle_mag_reload_animation_player.play("show_mag")
	
	if WaveManager.current_wave == 0:
		SignalBus.start_total_timer.emit()
	
	if GameManager.ammo_count <=0:
		show_reload_notification()
	
	SignalBus.start_wave.emit()

func show_added_score_label(score : int, head_shot : bool) -> void:
	if head_shot:
		added_score.text =  "+%s Head Shot!" % [score]
	else:
		added_score.text = "+%s" % [score]
	added_score_label_player.play("show_added_score")
	#added_score_label_timer.start()
	
func stop_wave() -> void:
	score_count.hide()
	score_label.hide()
	added_score_label_player.play("hide_health")
	hide_reload_notification()

	grenade_icon_player.play("HideGrenade")
	stop_music()
	if pistol_mag_showing:
		magazine_reload_animation_player.play("hide_mag") #don't actually set var false so we can show the appropriate mag when next round starts
	
	elif rifle_mag_showing:
		rifle_mag_reload_animation_player.play("hide_mag")
	
	
	reset_combo_meter()
	#this maybe where I handle starting the next wave?
	timer.start()
	pass

func swap_to_pistol():
	magazine_reload_animation_player.play("show_mag")
	rifle_mag_reload_animation_player.play("hide_mag")
	pistol_mag_showing = true
	rifle_mag_showing = false

func swap_to_rifle():
	magazine_reload_animation_player.play("hide_mag")
	rifle_mag_reload_animation_player.play("show_mag")
	pistol_mag_showing = false
	rifle_mag_showing = true

func _on_timer_timeout() -> void:
	var wave : Dictionary = WaveManager.waves[WaveManager.current_wave]
	if wave["cut_scene"]:
		#play the cut scene -- this will have the init count play at the end
		Dialogic.start(wave["cut_scene"])
	else:
		init_count_down()

func update_score() -> void:
	score_count.text = str(GameManager.score)
	
@onready var boss_health_bar_player: AnimationPlayer = $BossHealthBarPlayer

func show_boss_hp() -> void:
	boss_health_bar_player.play("show_boss_hp")

func fill_boss_hp() -> void:
	while boss_hp.value < boss_hp.max_value:
		boss_hp.value += 1
		await get_tree().create_timer(0.02).timeout
	
	boss_hp.max_value = GameManager.boss_health
	boss_hp.value = boss_hp.max_value	
	

func play_game_over_fade() -> void:
	animation_player.play("Dead")

func update_ammo_count() -> void:
	clear_box(bullets)
	for i in GameManager.ammo_count:
		var bullet : TextureRect = TextureRect.new()
		bullet.texture = preload("uid://bqq433bs811mc")
		bullets.add_child(bullet)
	pistol_mag_ammo_label.text = "%s/%s"%[GameManager.ammo_count, GameManager.PISTOL_MAGAZINE_SIZE]

@onready var rifle_mag_ammo_label: Label = $HUD/RifleMagazine/RifleMagAmmoLabel


func update_rifle_ammo_count() -> void:
	clear_box(rifle_bullets)
	for i in GameManager.rifle_mag_ammo_count:
		var bullet : TextureRect = TextureRect.new()
		bullet.texture = preload("uid://b1wsna7q68tru")
		rifle_bullets.add_child(bullet)
		
	rifle_mag_ammo_label.text = "%s/%s"%[GameManager.rifle_mag_ammo_count, GameManager.rifle_ammo_count]


func reload_pistol() -> void:
	GameManager.ammo_count = GameManager.PISTOL_MAGAZINE_SIZE
	update_ammo_count()

func clear_box(hbox) -> void:
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
		

func decrement_combo_meter_kill_count() -> void:
	
	combo_meter_timer.wait_time = combo_meter_wait_time
	combo_meter_timer.start()
	GameManager.kills_left -= 1
	
	if GameManager.current_multiplier >= 2:
		AudioManager.play_sfx(AudioManager.POINTINCREASE, 2)
	
	if GameManager.kills_left <= 0:
		GameManager.kills_left = GameManager.KILLS_NEEDED
		GameManager.current_multiplier += 1
		if GameManager.current_multiplier == 2:
			AudioManager.play_sfx(AudioManager.COMBOSTART)
			combo_meter_showing = true
			combo_meter_animation_player.play("show_combo_meter")
		if GameManager.current_multiplier > GameManager.highest_multiplier:
			GameManager.highest_multiplier = GameManager.current_multiplier
	
	update_combo_meter_label()

func reset_combo_meter() -> void:
	if combo_meter_showing:
		AudioManager.play_sfx(AudioManager.COMBOEND)
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
	
func play_count_down_beep() -> void:
	AudioManager.play_sfx(AudioManager.COUNTDOWN_BEEP)

func play_count_down_beep_down() -> void:
	AudioManager.play_sfx(AudioManager.COUNT_DOWN_BEEP_DONE)

func play_crowd_cheer() -> void:
	SignalBus.play_crowd_cheer.emit()

func stop_crowd_cheer() -> void:
	SignalBus.stop_crowd_cheer.emit()

func transition_to_game_over_screen() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/Menus/GameOverScreen.tscn")


func _on_added_score_label_timer_timeout() -> void:
	added_score_label_player.play("hide_added_score")


func _on_combo_meter_timer_timeout() -> void:
	reset_combo_meter()

func fade_to_win() -> void:
	animation_player.play("Win")

func go_to_win_screen() -> void:
	#TO BE REPLACE WITH ENDING CUTSCENE!!!!
	print("UMM??")
	get_tree().change_scene_to_file("res://src/Scenes/FinalCutScene.tscn")


func show_hud() -> void:
	score_label.show()
	score_count.show()
	total_timer.show()
	added_score_label_player.play("show_health")
	if GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL:
		magazine_reload_animation_player.play("show_mag")
	else:
		rifle_mag_reload_animation_player.play("show_mag")

func update_boss_hp() -> void:
	boss_hp.value = GameManager.boss_health

func show_grading_phrase(bonus: int) -> void:
	match bonus:
		3:
			grade_phrase.text = "GOOD JOB!"
			AudioManager.play_sfx(AudioManager.HOLDER_VOX_RADIO_PRAISE_01)
		2:
			grade_phrase.text = "GREAT!"
			AudioManager.play_sfx(AudioManager.HOLDER_VOX_RADIO_PRAISE_02)
		1:
			grade_phrase.text = "NOT BAD!"
			AudioManager.play_sfx(AudioManager.HOLDER_VOX_RADIO_PRAISE_03)
		-1:
			grade_phrase.text = "Clear!"
	
	grade_phrase_player.play("show_grade_phrase")

 
func issue_grenade() -> void:
	GameManager.can_throw_grenade = false
	reset_combo_meter()
	boss_health_bar_player.play("grenade_explosion")
	SignalBus.shake_camera.emit(1.4)
	AudioManager.play_sfx(AudioManager.GRENADEBLOW)
	
@onready var grenade_cooldown_timer: Timer = $GrenadeCooldownTimer

func start_grenade_cool_down() -> void:
	grenade_cooldown_timer.wait_time = GameManager.grenade_cool_down_time
	grenade_cooldown_timer.start()
	grenade_cool_down_label.show()
	

func kill_enemies_with_grenade() -> void:
	SignalBus.kill_enemy_by_grenade.emit(true)
	show_grading_phrase(-1)
	
func play_round_start_sfx() -> void:
	AudioManager.play_sfx(AudioManager.ROUNDSTART)


func _on_grenade_cooldown_timer_timeout() -> void:
	GameManager.can_throw_grenade = true
	boss_health_bar_player.play("grenade_ready")
	grenade_cool_down_label.hide()
