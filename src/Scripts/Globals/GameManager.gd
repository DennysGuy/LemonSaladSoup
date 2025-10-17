extends Node

const PLAYER_MAX_HEALTH : int = 5
const HEAD_SHOT_BONUS_MULTIPLIER : float = 1.2
const PISTOL_MAGAZINE_SIZE = 6
const RIFLE_MAGAZINE_SIZE = 10
const KILLS_NEEDED : int = 5


var player_is_alive : bool = true
var player_current_health : int = PLAYER_MAX_HEALTH
var retries : int = 0
var max_consecutive_shots : int = 0

var grenade_cool_down_time : int = 30
var can_throw_grenade : bool = false
var pistol_only_bonus : bool = true

var score : int = 0
var current_multiplier : int = 1

var waves_reset: bool = false
var kills_left: int = KILLS_NEEDED

var ammo_count : int = PISTOL_MAGAZINE_SIZE
var rifle_ammo_count : int = 50
var rifle_mag_ammo_count : int = 10

var boss_health : int = 3

var equipped_weapon : int = WEAPONS.PISTOL

var can_move : bool = false
var can_shoot : bool = false

var rifle_unlocked = false

var max_config_amount : int = 0

var total_shots_hit : int = 0
var final_time : String
var total_shots : int = 0
var total_head_shots : int = 0
var damage_taken : int = 0
var highest_multiplier : int = 0
var grenade_uses : int = 0
var total_kills : int = 0
var perfects : int = 0
var greats : int = 0
var okays : int = 0

#ending stats
var hit_percentage :float

enum WEAPONS  {
	PISTOL,
	RIFLE
}


func reset_game(retry : bool = false) -> void:
	if retry:
		retries += 1
	else:
		retries = 0
	
	equipped_weapon = WEAPONS.PISTOL
	rifle_unlocked = false
	player_is_alive = true
	player_current_health = PLAYER_MAX_HEALTH
	current_multiplier = 1
	total_shots_hit = 0
	total_shots = 0
	score = 0
	perfects = 0
	greats = 0
	okays = 0
	total_kills = 0
	damage_taken = 0
	total_head_shots = 0
	highest_multiplier = 0
	max_consecutive_shots = 0
	rifle_ammo_count = 50
	rifle_mag_ammo_count = 10
	final_time = ""
	pistol_only_bonus = true


enum GRADING_BONUS {
	PERFECT = 3,
	GREAT = 2,
	OKAY = 1
}

func get_hit_percentage() -> String:
	if total_shots == 0:
		return "0%"
		
	var percentage = float(total_shots_hit) / float(total_shots) * 100.0
	return str(round(percentage)) + "%"

func start_total_time() -> void:
	SignalBus.start_total_timer.emit()

func stop_total_timer() -> void:
	SignalBus.stop_total_timer.emit()
