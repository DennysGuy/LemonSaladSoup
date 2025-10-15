class_name ShooterEnemy extends Enemy

var player_in_range : bool = false

var strafe_left : bool = true

var dir_list : Array[String] = ["left", "right"]

var can_strafe : bool = true

const CHANCE_TO_SPAWN_AMMO :int = 55

@onready var movement_timer: Timer = $MovementTimer
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $bluegrunt/AnimationPlayer

var is_adjacent : bool = false

func _ready() -> void:
	super()
	SignalBus.add_enemy_to_list.emit(self)
	SignalBus.enemy_spawned.emit(self)
	state_machine.init(self)

func _process(delta : float) -> void:
	super(delta)
	state_machine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:	
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		queue_free()

func _on_player_sensor_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_range = true
		state_machine.change_state(attack_state)

func remove() -> void:
	queue_free()

func attack_player() -> void:
	player.damage_player()

func _on_bonus_timer_timeout() -> void:
	timer_bonus = 0
	can_receive_bonus = false

func spawn_rifle_drop() -> void:
	var rifle_drop : RifleDrop = preload("uid://b5qe5t1ktqakk").instantiate()
	rifle_drop.global_position = consumable_spawn_point.global_position
	arena.add_child(rifle_drop)
	
func spawn_ammo_drop() -> void:
	var random_num : int = randi_range(0,100)
	if random_num > CHANCE_TO_SPAWN_AMMO:
		return
	
	var ammo_drop : AmmoDrop = preload("uid://brl005mrnmblk").instantiate()
	ammo_drop.global_position = consumable_spawn_point.global_position
	arena.add_child(ammo_drop)
		
