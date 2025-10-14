class_name EnemyConfiguration extends Node3D

@export var enemies: Node3D


func _exit_tree() -> void:
	SignalBus.decrement_config_count.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemies.get_children().is_empty():
		queue_free()
