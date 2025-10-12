class_name WaveTimerLabel extends RichTextLabel


var seconds : int = 10
var milliseconds : int = 0

var timer_started : bool
@onready var marker_2d: Marker2D = $Marker2D

var seconds_tracker : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	#set_time(seconds,milliseconds)
	SignalBus.start_wave.connect(start_timer)
	SignalBus.decrement_wave_time.connect(decrement_wait_time)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"):
		#timer_started = true
	pass

func _physics_process(delta: float) -> void:
	if timer_started:
		if milliseconds == 0:
			seconds -= 1
			seconds_tracker += 1
			milliseconds = 100
				
			if seconds_tracker >= WaveManager.waves[WaveManager.current_wave]["decrement_interval"]:
				SignalBus.decrement_spawn_time.emit()
				seconds_tracker = 0
				
		else:
			milliseconds -= delta
		
		if seconds <= 0:
			stop_timer()
		
		set_time(seconds,milliseconds)
		
	
func set_time(added_seconds : int, added_milliseconds : int = 0) -> void:
	seconds = added_seconds
	milliseconds = added_milliseconds
	set_label()

func start_timer() -> void:
	timer_started = true

func stop_timer() -> void:
	seconds = 0
	milliseconds = 0
	
	if WaveManager.wave_started:
		hide()
		SignalBus.stop_wave.emit()
		WaveManager.wave_started = false
		
	timer_started = false


func decrement_wait_time(value : int) -> void:

	seconds -= value
	seconds_tracker += value
	if seconds < 0:
		seconds = 0
	
	milliseconds = 0
	
	var label : TimeDecrementLabel = preload("uid://c1srx6v31xvtu").instantiate()
	label.time = value
	label.position = get_parent().marker_2d.position
	get_parent().add_child(label)

func set_label() -> void:
	text = ""
	append_text("[font_size=64]%s[/font_size][font_size=24].%s[/font_size]" % [seconds,milliseconds])
