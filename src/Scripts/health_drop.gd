class_name HealthDrop extends Node3D

var move_to_player : bool = false
var player : Player
@onready var soup: Node3D = $Soup
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	animation_player.play("bob")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	soup.rotation.y += 0.02


func _physics_process(delta):
	if move_to_player:
		var target = player.magnet_point.global_position
		var speed = 30.0
		global_position = global_position.move_toward(target, speed * delta)


func _on_timer_timeout() -> void:
	move_to_player = true


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is ResourceCollisionPoint:
		#issue signal to flash the green to indicate health increase
		SignalBus.play_health_caught_anim.emit()
		queue_free()
