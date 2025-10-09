class_name TestEnemy extends CharacterBody3D

var player : Player
var speed  : float = 40
var health : int = 3

var alive : bool = true

@export var dead_state : State
@export var hurt_1_state : State
@export var hurt_2_state : State
@export var head_shot_dead : State

@onready var hurt_states : Array[State] = [hurt_1_state, hurt_2_state]

@onready var timer: Timer = $Timer

@onready var state_machine: StateMachine = $StateMachine

@onready var redgrunt_2: Node3D = $redgrunt2
@onready var animation_player: AnimationPlayer = $redgrunt2/AnimationPlayer

func _ready() -> void:
	
	player = get_tree().get_first_node_in_group("Player")
	SignalBus.enemy_spawned.emit(self)
	state_machine.init(self)
	#SignalBus.ping_enemies.connect(ping_player)

func _process(delta : float) -> void:
	state_machine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:	
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
	
func ping_player() -> void:
	#SignalBus.enemy_spawned.emit(self)
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		queue_free()

func damage_enemy() -> void:
	
	if not alive:
		return
	
	var chosen_state : State = hurt_states.pick_random()
	state_machine.change_state(chosen_state)
	
	health -= 1
	if health <= 0:
		kill_enemy()

func kill_enemy() -> void:
	if not alive:
		return
	
	state_machine.change_state(dead_state)

func head_shot_kill() -> void:
	if not alive:
		return
	
	state_machine.change_state(head_shot_dead)
