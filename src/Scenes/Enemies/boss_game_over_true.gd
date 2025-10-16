class_name BossManGameOverTrue extends Node3D

@onready var animation_player: AnimationPlayer = $boss/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("justchillin")
	SignalBus.make_boss_laugh.connect(make_boss_laugh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_boss_laugh() -> void:
	animation_player.play("talk")
