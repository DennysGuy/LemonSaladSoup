class_name SprinterEnemy extends Enemy

var player_in_range : bool = false
@onready var animation_player: AnimationPlayer = $yellowgrunt2/AnimationPlayer

@onready var timer: Timer = $Timer

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
