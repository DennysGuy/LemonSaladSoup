extends Node

@onready var walker = preload("uid://coiyr773xvwd4")
@onready var sprinter = preload("uid://caus2ij86avcu")
@onready var shooter = preload("uid://bqbj7je120a8g")

const MAX_WAVE :int = 2

@onready var waves : Dictionary = {
	
	0 : {
		"time": 60,
		"decrement_interval": 20,
		"decrement_amount": 1,
		"kill_quota":30,
		"spawn_time":7, #in seconds
		"enemies": [
			{"scene": walker, "weight": 80},
		],
		"cut_scene": null #this plays at the end of the wave?
	},
	
	1 : {
		"time": 90,
		"decrement_interval": 20,
		"decrement_around": 0.5,
		"kill_quota":60,
		"spawn_time":8, #in seconds
		"enemies": [
			{"scene": walker, "weight": 75},
			{"scene": sprinter, "weight": 50}
		],
		"cut_scene": null,
	},
	
	2 : {
		"time": 180,
		"decrement_interval":9,
		"kill_quota":200,
		"spawn_time":7, #in seconds
		"decrement_around": 0.5,
		"enemies": [
			{"scene": walker, "weight": 75},
			{"scene": sprinter, "weight": 50},
			{"scene": shooter, "weight": 40}
		],
		"cut_scene": null,
	}
	
}


var current_wave : int = -1
var wave_started : bool = false


func get_weighted_enemy() -> PackedScene:
	var enemies : Array = waves[current_wave]["enemies"]
	
	var total_weight = 0
	for e in enemies:
		total_weight += e["weight"]
	
	var pick = randi() % total_weight
	var current = 0
	
	for e in enemies:
		current += e["weight"]
		if pick < current:
			return e.scene
	
	return null 

func move_to_next_wave() -> void:
	if current_wave == MAX_WAVE:
		return
	
	current_wave += 1

func reset() -> void:
	current_wave = -1
	wave_started = false
