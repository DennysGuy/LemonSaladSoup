extends Node

const PLAYER_MAX_HEALTH : int = 5
const HEAD_SHOT_BONUS_MULTIPLIER : float = 1.5
const PISTOL_MAGAZINE_SIZE = 6
const RIFLE_MAGAZINE_SIZE = 10
const KILLS_NEEDED : int = 5

var player_is_alive : bool = true
var player_current_health : int = PLAYER_MAX_HEALTH

var score : int = 0
var current_multiplier : int = 1

var kills_left: int = KILLS_NEEDED

var ammo_count : int = PISTOL_MAGAZINE_SIZE
var rifle_ammo_count : int = 50
var rifle_mag_ammo_count : int = 10


var equipped_weapon : int = WEAPONS.PISTOL

var can_move : bool = false
var can_shoot : bool = false

var rifle_unlocked = false

enum WEAPONS  {
	PISTOL,
	RIFLE
}


func reset_game() -> void:
	equipped_weapon = WEAPONS.PISTOL
	rifle_unlocked = false
	player_is_alive = true
	player_current_health = PLAYER_MAX_HEALTH
	current_multiplier = 1
	score = 0


enum GRADING_BONUS {
	PERFECT = 3,
	GREAT = 2,
	OKAY = 1
}
