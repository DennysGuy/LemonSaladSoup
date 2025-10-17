class_name BossMan extends Enemy

@onready var animation_player: AnimationPlayer = $boss/AnimationPlayer
@onready var force_field_player: AnimationPlayer = $ForceFieldPlayer
@onready var party_hat: Node3D = $PartyHat


func _ready() -> void:
	super()
	is_boss = true
	party_hat.hide()
	var random_number : int = randi_range(0,100)
	if random_number <= 30:
		party_hat.show()
	
	SignalBus.enemy_spawned.emit(self)
	SignalBus.reflect_bullet.connect(play_reflection)
	SignalBus.disable_force_field.connect(disable_force_field)
	state_machine.init(self)

func _process(delta : float) -> void:
	super(delta)
	state_machine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:	
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func play_reflection() -> void:
	force_field_player.play("react")
	
@onready var force_field_collision_shape: CollisionShape3D = $ForceFieldArea/CollisionShape3D


func disable_force_field() -> void:
	force_field_collision_shape.disabled = true

func play_just_chillin() -> void:
	animation_player.play("justchillin")
