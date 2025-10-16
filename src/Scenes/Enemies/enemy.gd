class_name Enemy extends CharacterBody3D

var player : Player
var prev_state : State
var arena : Arena

@export_group("Enemy Stats")
@export var move_speed  : float = 40
@export var health : int = 3
@export var base_score : int
@export var grunt_death_pitch : float
@export var consumable_spawn_point : Marker3D

@export var body_flash_point : Marker3D
@export var head_flash_point : Marker3D

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
	arena = get_tree().get_first_node_in_group("Arena")
	player = get_tree().get_first_node_in_group("Player")
	bonus_timer.start()
	bonus_timer.wait_time = bonus_wait_time
	bonus_timer.start()
	SignalBus.kill_enemy_by_grenade.connect(kill_enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_receive_bonus:
		set_timer_bonus()
	else:
		timer_bonus = 0

func kill_enemy(killed_by_grenade : bool = false) -> void:
	if not alive:
		return
		
	if killed_by_grenade and is_boss:
		return
	
	alive = false
	
	GameManager.total_kills += 1
	
	if can_receive_bonus:
		SignalBus.remove_one_kill.emit()
	
	if killed_by_grenade:
		AudioManager.play_sfx(AudioManager.enemy_deaths.pick_random(),-3)
	else:
		AudioManager.play_sfx(AudioManager.enemy_deaths.pick_random(),-2)
	# lock in bonus here
	timer_bonus = set_timer_bonus()

	var score = base_score
	
	if not killed_by_grenade:
		update_score(score, false)
		
	state_machine.change_state(dead_state)


func head_shot_kill() -> void:
	if not alive:
		return
	
	if is_boss:
		GameManager.boss_health = 0
		SignalBus.update_boss_hp.emit()
	
	GameManager.total_kills += 1
	GameManager.total_head_shots += 1
	
	alive = false
	
	AudioManager.play_sfx(AudioManager.head_shots.pick_random(),4)
	AudioManager.play_sfx(AudioManager.enemy_deaths.pick_random(),-2,true)
	
	generate_hit_star_hs(head_flash_point, 2)
	
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
	
	
	AudioManager.play_sfx(AudioManager.head_shots.pick_random(),2,true)
	generate_hit_star(body_flash_point,4)
	
	var chosen_state : State = hurt_states.pick_random()
	state_machine.change_state(chosen_state)
	
	health -= 1
	if health <= 0:
		kill_enemy()


func update_score(value : int, head_shot : bool) -> void:
	var added_score = value
	#handle bonuses
	if can_receive_bonus:
		added_score *= timer_bonus
		SignalBus.show_grade_phrase.emit(timer_bonus)
		SignalBus.decrement_wave_time.emit(timer_bonus)
		if timer_bonus == GameManager.GRADING_BONUS.PERFECT:
			GameManager.perfects += 1
		elif timer_bonus == GameManager.GRADING_BONUS.GREAT:
			GameManager.greats += 1
		else:
			GameManager.okays += 1
		

	added_score *= GameManager.current_multiplier
	
	SignalBus.show_added_score_label.emit(added_score,head_shot)
	
	GameManager.score += added_score
	SignalBus.update_score_label.emit()


func spawn_health_drop() -> void:
	var random_num : int = randi_range(0,100)
	var chance_to_get_health : int
	
	if GameManager.player_current_health == 4:
		chance_to_get_health = 5
	elif GameManager.player_current_health == 3:
		chance_to_get_health = 8
	elif GameManager.player_current_health == 2:
		chance_to_get_health = 15
	else:
		chance_to_get_health = 25
	
	if random_num > chance_to_get_health:
		return
		

	var health_drop : HealthDrop = preload("uid://d1k5jp5vibp8l").instantiate()
	health_drop.global_position = consumable_spawn_point.global_position
	arena.add_child(health_drop)


func set_timer_bonus() -> int:
	var bonus : int = int((bonus_timer.time_left / bonus_wait_time) * 100)
	
	if bonus >= 60:
		return GameManager.GRADING_BONUS.PERFECT
	elif bonus >= 20:
		return GameManager.GRADING_BONUS.GREAT
	else:
		return GameManager.GRADING_BONUS.OKAY

func generate_hit_star_hs(location : Marker3D, size : float = 1.0) -> void:
	var hit_flash_hs : HitFlash = preload("uid://1koe5d4rrakq").instantiate()
	hit_flash_hs.scale = Vector3(size,size,size)
	hit_flash_hs.position = location.position
	add_child(hit_flash_hs)
	
func generate_hit_star(location : Marker3D, size : float = 1.0) -> void:
	var hit_flash : HitFlash = preload("uid://ch5rydauxhk0i").instantiate()
	hit_flash.scale = Vector3(size,size,size)
	hit_flash.position = location.position
	add_child(hit_flash)

func play_random_player_hit_sfx() -> void:
	AudioManager.play_sfx(AudioManager.attack_hits.pick_random(),4)

func play_random_swipe_sfx() -> void:
	AudioManager.play_sfx(AudioManager.attack_swipes.pick_random(),5)

func play_cannon_shot_sfx() -> void:
	AudioManager.play_sfx(AudioManager.CANNON,3)
