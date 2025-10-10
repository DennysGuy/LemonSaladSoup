class_name WalkerEnemy extends Enemy

@onready var timer: Timer = $Timer

@onready var redgrunt_2: Node3D = $redgrunt2
@onready var animation_player: AnimationPlayer = $redgrunt2/AnimationPlayer
@onready var bonus_timer: Timer = $BonusTimer

@onready var body: MeshInstance3D = $redgrunt2/redgrunt/Skeleton3D/body
@onready var shader_mat := body.get_active_material(0)

var player_in_range : bool = false

func _ready() -> void:
	#shader_mat.set_shader_parameter("fire_color", Color(0.0, 0.3, 1.0))
	print(shader_mat)
	player = get_tree().get_first_node_in_group("Player")
	SignalBus.enemy_spawned.emit(self)
	state_machine.init(self)

func _process(delta : float) -> void:
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


func attack_player() -> void:
	player.damage_player()
