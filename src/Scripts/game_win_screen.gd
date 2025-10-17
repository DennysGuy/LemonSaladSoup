class_name GameWinScreen extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Title
@onready var perfect_run_player: AnimationPlayer = $PerfectRunPlayer

@onready var score: Label = $Score
@onready var final_time: Label = $FinalTime
@onready var damage_taken: Label = $DamageTaken
@onready var grenade_uses: Label = $GrenadeUses
@onready var highest_combo_multiplier: Label = $HighestComboMultiplier
@onready var accuracy: Label = $Accuracy
@onready var total_shots: Label = $TotalShots
@onready var total_shots_landed: Label = $TotalShotsLanded
@onready var perfects: Label = $Perfects
@onready var greats: Label = $Greats
@onready var okays: Label = $Okays
@onready var kills: Label = $Kills
@onready var retries: Label = $Retries
@onready var consecutive_shots: Label = $ConsecutiveShots
@onready var pistol_bonus: Label = $PistolBonus


var slogans : Array[String] = [
	"A Fool of a Took.",
	"Reality isn't what it always seems...",
	"Can I trouble you a glass of warm milk?",
	"You can trouble me for a glass of shut the hell up!",
	"You will go to sleep, or I will put you to sleep!",
	"Two for the Price of 1",
	"We don't always get what we want in life",
	"Great job.. you're only human though.",
	"You defeated evil, but True evil was your demise.",
	"EXCELLENT... but let's go better next time.",
	"As they say.. live to ride and ride to live!",
	"Survival of the Fittest.",
	"This clown who thinks they're 'James Wick'..",
	"Hell and Taxes",
	"Come back any time!",
	"You can't have any of my tots, gosh!",
	"Objection!",
	"You're pretty good."
] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_num = randi_range(0,slogans.size()-1)
	label.text = slogans[random_num]
	
	if GameManager.pistol_only_bonus:
		score.text = "Score: %s" % [GameManager.score + 50000]
		pistol_bonus.text = "Pistol Only Bonus: 50000"
	else:
		score.text = "Score: %s" % [GameManager.score]
		pistol_bonus.text = "Pistol Only Bonus: 0"
		
	final_time.text = "Final Time: %s" % [GameManager.final_time]
	damage_taken.text = "Damage Taken: %s" % [GameManager.damage_taken]
	grenade_uses.text = "Grenade Uses: %s" % [GameManager.grenade_uses]
	highest_combo_multiplier.text = "Highest Combo Multiplier: %s" % [GameManager.highest_multiplier]
	accuracy.text = "Accuracy: %s" % [GameManager.get_hit_percentage()]
	total_shots.text = "Total Shots: %s" % [GameManager.total_shots]
	total_shots_landed.text = "Total Shots Landed: %s" % [GameManager.total_shots_hit]
	perfects.text = "Perfects': %s" % [GameManager.perfects]
	greats.text = "Greats': %s" % [GameManager.greats]
	okays.text = "Okays': %s" % [GameManager.okays]
	kills.text = "Total Kills: %s" % [GameManager.total_kills]
	retries.text = "Retries: %s" % [GameManager.retries]
	consecutive_shots.text = "Consecutive Shots: %s" % [GameManager.max_consecutive_shots]
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	animation_player.play("fade_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_replay_button_up() -> void:
	AudioManager.stop_music_player()
	GameManager.waves_reset = true
	GameManager.reset_game()
	WaveManager.reset()
	animation_player.play("fade_out")


func _on_main_menu_button_up() -> void:
	GameManager.waves_reset = false
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://src/Scenes/Menus/MainMenu.tscn")


func go_to_main() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/Main.tscn")


func _on_timer_timeout() -> void:
	if GameManager.retries == 0 and GameManager.grenade_uses == 0 and GameManager.damage_taken == 0:
		AudioManager.play_sfx(AudioManager.VOX_ANNOUNCER_SHOT_PERFECT_02)
		AudioManager.play_sfx(AudioManager.BONUS)
		perfect_run_player.play("ShowPerfectRun")
		
