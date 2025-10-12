class_name BossMan extends Enemy

@onready var animation_player: AnimationPlayer = $boss/AnimationPlayer


func _ready() -> void:
	super()
	SignalBus.enemy_spawned.emit(self)
	state_machine.init(self)

func _process(delta : float) -> void:
	super(delta)
	state_machine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:	
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
