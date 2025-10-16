class_name AmmoDrop extends Node3D

@onready var marker_3d: Marker3D = $Marker3D

@onready var ammo_amount : int = randi_range(24,35)

var player : Player
var move_to_player : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	marker_3d.rotation.y += 0.02

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
		if GameManager.rifle_ammo_count <= 0:
			GameManager.rifle_ammo_count = 50
			GameManager.rifle_mag_ammo_count = 10
			SignalBus.update_rifle_ammo.emit()
			SignalBus.play_ammo_retrieved_flash.emit()
			SignalBus.swap_to_rifle.emit()
			SignalBus.swap_to_rifle_first_time.emit()
	
		else:
			GameManager.rifle_ammo_count += ammo_amount
			SignalBus.update_rifle_ammo.emit()
	
		AudioManager.play_sfx(AudioManager.RIFLEDRAW)
		queue_free()
