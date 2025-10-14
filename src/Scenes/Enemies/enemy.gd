class_name Enemy extends CharacterBody3D

var player : Player
var prev_state : State


@export_group("Enemy Stats")
@export var move_speed  : float = 40
@export var health : int = 3
@export var base_score : int
@export var grunt_death_pitch : float

@export_group("Damage States")
@export var dead_state : State
@export var attack_state : State
@export var hurt_1_state : State
@export var hurt_2_state : State
@export var head_shot_dead : State
@export var reflect_state : State

#@export_group("Sounds")
#@export var head_shot_effect : AudioStream
#@export var scream_effect : AudioStream
#@export var grunt_effect : AudioStream

var can_receive_bonus : bool = true

var is_boss : bool = false

@onready var state_machine : StateMachine = $StateMachine
@onready var hurt_states : Array[State] = [hurt_1_state, hurt_2_state]
@onready var bonus_timer: Timer = $BonusTimer

@export var bonus_wait_time : int = 8

var alive : bool = true
var timer_bonus : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#death_sfx_player.stream = scream_effect
	#head_shot_sfx_player.stream = head_shot_effect
	#grunt_sfx_player.stream = grunt_effect
	
	player = get_tree().get_first_node_in_group("Player")
	bonus_timer.start()
	bonus_timer.wait_time = bonus_wait_time
	bonus_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_receive_bonus:
		set_timer_bonus()
	else:
		timer_bonus = 0

func kill_enemy() -> void:
	if not alive:
		return
		
	alive = false
	
	if can_receive_bonus:
		SignalBus.remove_one_kill.emit()
	
	AudioManager.play_sfx(AudioManager.HOLDER_VOX_ENE_DEAD)
	# lock in bonus here
	timer_bonus = set_timer_bonus()

	var score = base_score
	update_score(score, false)
	state_machine.change_state(dead_state)


func head_shot_kill() -> void:
	if not alive:
		return
	
	if is_boss:
		GameManager.boss_health = 0
		SignalBus.update_boss_hp.emit()
	
	alive = false
	
	AudioManager.play_sfx(AudioManager.HEADSHOT_2,2,true)
	AudioManager.play_sfx(AudioManager.HOLDER_VOX_ENE_DEAD,2,true)
	
	if can_receive_bonus:
		SignalBus.remove_one_kill.emit()

	# lock in bonus here
	timer_bonus = set_timer_bonus()

	var score : int = int(base_score * GameManager.HEAD_SHOT_BONUS_MULTIPLIER)
	update_score(score, true)
	state_machine.change_state(head_shot_dead)


func damage_enemy() -> void:
	if not alive:	
		return
	
	if is_boss:
		GameManager.boss_health -= 1
		SignalBus.update_boss_hp.emit()
	
	AudioManager.play_sfx(AudioManager.HEADSHOT_1,2,true)
	
	
	var chosen_state : State = hurt_states.pick_random()
	state_machine.change_state(chosen_state)
	
	health -= 1
	if health <= 0:
		kill_enemy()


func update_score(value : int, head_shot : bool) -> void:
	var added_score = value
	#handle bonuses
	if can_receive_bonus:
		added_score *= (10 * timer_bonus)
		SignalBus.show_grade_phrase.emit(timer_bonus)
		SignalBus.decrement_wave_time.emit(timer_bonus)

	added_score *= GameManager.current_multiplier
	
	SignalBus.show_added_score_label.emit(added_score,head_shot)
	
	GameManager.score += added_score
	SignalBus.update_score_label.emit()


func set_timer_bonus() -> int:
	var bonus : int = int((bonus_timer.time_left / bonus_wait_time) * 100)
	
	if bonus >= 70:
		return GameManager.GRADING_BONUS.PERFECT
	elif bonus >= 50:
		return GameManager.GRADING_BONUS.GREAT
	else:
		return GameManager.GRADING_BONUS.OKAY
