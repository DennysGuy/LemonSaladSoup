extends Node

@onready var walker = preload("uid://coiyr773xvwd4")

const MAX_WAVE :int = 2

var waves : Dictionary = {
	
	0 : {
		"time": 60,
		"decrement_interval": 20,
		"kill_quota":30,
		"spawn_time":7, #in seconds
		"enemies": [walker],
		"spawn_weights":[100],
		"cut_scene": null #this plays at the end of the wave?
	},
	
	1 : {
		"time": 90,
		"decrement_interval": 20,
		"kill_quota":60,
		"spawn_time":6, #in seconds
		"enemies": [walker],
		"spawn_weights":[100],
		"cut_scene": null,
	},
	
	2 : {
		"time": 180,
		"decrement_interval":9,
		"kill_quota":200,
		"spawn_time":8, #in seconds
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
