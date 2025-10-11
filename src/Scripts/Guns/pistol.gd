class_name Pistol extends Node3D

@onready var muzzle: Marker3D = $Muzzle
@onready var camera: Camera3D = $Camera3D

@onready var pistol_sfx : Array[AudioStream] = [AudioManager.PISTOLDRY_1, AudioManager.PISTOLDRY_2, AudioManager.PISTOLDRY_3]
@onready var gun: Node3D = $Gun
var reticle_offset := Vector2(-90,0)
@export var max_arm_offset: Vector2 = Vector2(600, 300) # how far the arm can move on screen
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func apply_muzzle() -> void:
	var muzzle_flash = preload("uid://c32dc8g4xyoc3").instantiate()

	muzzle.add_child(muzzle_flash)
	await get_tree().create_timer(0.05).timeout
	muzzle_flash.queue_free()

func enable_shooting():
	GameManager.can_shoot = true

func play_pistol_shot() -> void:
	var random_shot : AudioStream = pistol_sfx.pick_random()
	play_sfx(random_shot)

func play_pistol_reload() -> void:
	var reload_sfx : AudioStream = AudioManager.PISTOL_RELOAD_EDIT_1
	play_sfx(reload_sfx)

func play_sfx(audio_stream : AudioStream, volume_db : float = 0.0, randomized_pitch : bool = false) -> void:
	var asp : AudioStreamPlayer = AudioStreamPlayer.new()
	asp.stream = audio_stream
	asp.volume_db = volume_db
	
	if randomized_pitch:
		asp.pitch_scale = randomize_pitch()
		
	asp.bus = "SFX"
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()

func randomize_pitch() -> float:
	return randf_range(0.5,0.7)	

func enable_movement() -> void:
	SignalBus.enable_movement.emit()

func disable_movement() -> void:
	SignalBus.disable_movement.emit()
