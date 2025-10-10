class_name Enemy extends CharacterBody3D

var player : Player

@export_group("Enemy Stats")
@export var move_speed  : float = 40
@export var health : int = 3
@export var base_score : int

@export_group("Damage States")
@export var dead_state : State
@export var attack_state : State
@export var hurt_1_state : State
@export var hurt_2_state : State
@export var head_shot_dead : State

var can_receive_bonus : bool = true

@onready var state_machine : StateMachine = $StateMachine
@onready var hurt_states : Array[State] = [hurt_1_state, hurt_2_state]


var alive : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func kill_enemy() -> void:
	if not alive:
		return
	SignalBus.increment_kill_count.emit()
	var score = base_score
	update_score(score)
	state_machine.change_state(dead_state)

func head_shot_kill() -> void:
	if not alive:
		return
	SignalBus.increment_kill_count.emit()
	
	var score : int = int(base_score * GameManager.HEAD_SHOT_BONUS_MULTIPLIER)
	update_score(score)
	
	state_machine.change_state(head_shot_dead)

func damage_enemy() -> void:
	if not alive:
		return
	
	var chosen_state : State = hurt_states.pick_random()
	state_machine.change_state(chosen_state)
	
	health -= 1
	if health <= 0:
		kill_enemy()


func update_score(value : int) -> void:
	var added_score = value
	#handle bonuses
	if can_receive_bonus:
		pass
	
	GameManager.score += added_score * GameManager.current_multiplier
	SignalBus.update_score_label.emit()
