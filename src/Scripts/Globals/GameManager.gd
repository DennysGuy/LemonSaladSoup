extends Node

const PLAYER_MAX_HEALTH : int = 5
const HEAD_SHOT_BONUS_MULTIPLIER : float = 1.5
const PISTOL_MAGAZINE_SIZE = 6
const KILLS_NEEDED : int = 5

var player_is_alive : bool = true
var player_current_health : int = PLAYER_MAX_HEALTH

var score : int = 0
var current_multiplier : int = 1

var kills_left: int = KILLS_NEEDED

var ammo_count : int = PISTOL_MAGAZINE_SIZE

var equipped_weapon : int = WEAPONS.PISTOL

var can_move : bool = false
var can_shoot : bool = false

enum WEAPONS  {
	PISTOL,
	RIFLE
}


func reset_game() -> void:

	player_is_alive = true
	player_current_health = PLAYER_MAX_HEALTH
	score = 0


enum GRADING_BONUS {
	PERFECT = 3,
	GREAT = 2,
	OKAY = 1
}
