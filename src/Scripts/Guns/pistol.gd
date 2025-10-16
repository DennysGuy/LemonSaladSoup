class_name Pistol extends Node3D

@onready var muzzle: Marker3D = $Muzzle
@onready var rifle_muzzle: Marker3D = $RifleMuzzle
@onready var ar: Node3D = $AR

@onready var camera: Camera3D = $Camera3D
@onready var pistol_sfx : Array[AudioStream] = [AudioManager.PISTOL_1, AudioManager.PISTOL_2, AudioManager.PISTOL_3]
@onready var rifle_sfx : Array[AudioStream] = [AudioManager.RIFLE_1, AudioManager.RIFLE_2, AudioManager.RIFLE_3, AudioManager.RIFLE_4]
@onready var gun: Node3D = $Gun
var reticle_offset := Vector2(-90,0)
@export var max_arm_offset: Vector2 = Vector2(600, 300) # how far the arm can move on screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.equipped_weapon = GameManager.WEAPONS.PISTOL
	SignalBus.set_weapon_visual.connect(set_weapon_visual)
	set_weapon_visual()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func apply_muzzle() -> void:
	var muzzle_flash = preload("uid://c32dc8g4xyoc3").instantiate()
	
	match GameManager.equipped_weapon:
		GameManager.WEAPONS.PISTOL:
			muzzle.add_child(muzzle_flash)
		GameManager.WEAPONS.RIFLE:
			rifle_muzzle.add_child(muzzle_flash)
	await get_tree().create_timer(0.05).timeout
	muzzle_flash.queue_free()

func enable_shooting():
	GameManager.can_shoot = true

func play_pistol_shot() -> void:
	var random_shot : AudioStream = pistol_sfx.pick_random()
	AudioManager.play_sfx(random_shot)

func play_rifle_shot() -> void:
	var random_shot : AudioStream = rifle_sfx.pick_random()
	AudioManager.play_sfx(random_shot)

func play_pistol_reload() -> void:
	var reload_sfx : AudioStream = AudioManager.PISTOLRELOAD
	AudioManager.play_sfx(reload_sfx)

func play_weapon_holster() -> void:
	var sfx : AudioStream 
	if GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL:
		sfx = AudioManager.PISTOLHOLSTER
	else:
		sfx = AudioManager.RIFLEHOLSTER
	
	AudioManager.play_sfx(sfx)
	
func play_weapon_draw() -> void:
	var sfx : AudioStream 
	if GameManager.equipped_weapon == GameManager.WEAPONS.PISTOL:
		sfx = AudioManager.PISTOLDRAW
	else:
		sfx = AudioManager.RIFLEDRAW
	AudioManager.play_sfx(sfx)


func set_weapon_visual() -> void:
	match GameManager.equipped_weapon:
		GameManager.WEAPONS.PISTOL:
			gun.show()
			ar.hide()
		GameManager.WEAPONS.RIFLE:
			ar.show()
			gun.hide()

func enable_movement() -> void:
	SignalBus.enable_movement.emit()

func disable_movement() -> void:
	SignalBus.disable_movement.emit()

func issue_grenade() -> void:
	SignalBus.issue_grenade.emit()
