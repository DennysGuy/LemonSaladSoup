extends Node

@onready var walker = preload("uid://coiyr773xvwd4")

const MAX_WAVE :int = 2

var waves : Dictionary = {
	
	0 : {
		"time": 30,
		"kill_quota":10,
		"spawn_time":3, #in seconds
		"enemies": [walker],
		"spawn_weights":[100],
		"cut_scene": null #this plays at the end of the wave?
	},
	
	1 : {
		"time": 40,
		"kill_quota":15,
		"spawn_time": 2, #in seconds
		"enemies": [walker],
		"spawn_weights":[100],
		"cut_scene": null,
	},
	
	2 : {
		"time": 50,
		"kill_quota":20,
		"spawn_time":1, #in seconds
		"enemies": [walker],
		"spawn_weights":[100],
		"cut_scene": null,
	}
	
}

var current_wave : int = -1
var wave_started : bool = false

func move_to_next_wave() -> void:
	if current_wave == MAX_WAVE:
		return
	
	current_wave += 1
