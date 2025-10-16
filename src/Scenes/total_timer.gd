class_name TotalTimer extends Label


@export var start_time: float = 0.0 # seconds to start counting from
var elapsed_time: float
var timer_started : bool = false

func _ready():
	SignalBus.start_total_timer.connect(start_timer)
	SignalBus.stop_total_timer.connect(stop_timer)
	elapsed_time = start_time
	text = get_time_string()

func _physics_process(delta: float) -> void:
	if timer_started:
		elapsed_time += delta
		text = get_time_string()
func start_timer() -> void:
	timer_started = true

func stop_timer() -> void:
	timer_started = false
	GameManager.final_time = get_time_string()

# Returns the timer in mm:ss format
func get_time_string() -> String:
	var minutes: int = int(elapsed_time) / 60
	var seconds: int = int(elapsed_time) % 60
	return "%02d:%02d" % [minutes, seconds]
