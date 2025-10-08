extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var connected_area : Area3D
var alarm_on : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#hide()
	#SignalBus.alert_player.connect(alert_player)
	SignalBus.silence_alarm.connect(hide_alert)
	animation_player.play("blink")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func alert_player(detector : Area3D) -> void:
	if connected_area == detector:
		alarm_on = true
		print(detector)
		show()
		animation_player.play("blink")

func hide_alert() -> void:
	if alarm_on:
		animation_player.stop()
		hide()
	
