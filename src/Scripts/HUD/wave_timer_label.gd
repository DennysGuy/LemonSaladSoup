class_name WaveTimerLabel extends RichTextLabel


var seconds : int = 10
var milliseconds : int = 0

var timer_started : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_time(seconds,milliseconds)
	SignalBus.start_wave.connect(start_timer)
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
			milliseconds = 100	
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

func set_label() -> void:
	text = ""
	append_text("[font_size=64]%s[/font_size][font_size=24].%s[/font_size]" % [seconds,milliseconds])
