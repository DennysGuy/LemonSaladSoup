extends Node

@onready var walker = preload("uid://coiyr773xvwd4")
@onready var sprinter = preload("uid://caus2ij86avcu")
@onready var shooter = preload("uid://bqbj7je120a8g")

const MAX_WAVE :int = 2

@onready var waves : Dictionary = {
	
	0 : {
		"time": 120,
		"starting config amount": 1,
		"stagger_time":2,
		"spawn_time":2, #in seconds
		"config list": wave_1_configurations,
		"cut_scene": null #this plays at the end of the wave?
	},
	
	1 : {
		"time": 180,
		"starting config amount": 2,
		"stagger_time":2.2,
		"spawn_time":1.8, #in seconds
		"config list": wave_2_configurations,
		"cut_scene": null,
	},
	
	2 : {
		"time": 240,
		"starting config amount": 2,
		"stagger_time":1.8,
		"spawn_time":1.5, #in seconds
		"config list": wave_3_configurations,
		"cut_scene": "BossFight",
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

func start_wave() -> void:
	SignalBus.initialize_countdown.emit()


func reset() -> void:
	current_wave = -1
	wave_started = false

#wave 1 configurations
const CONFIGURATION_1 = preload("uid://bj5khgau70ald")
const CONFIGURATION_2 = preload("uid://pbly6tx7laxw")
const CONFIGURATION_3 = preload("uid://d32bma0knbdjd")
const CONFIGURATION_4 = preload("uid://dlpsfnr5it8y5")
const CONFIGURATION_5 = preload("uid://dccp6uhg5jbe4")
const CONFIGURATION_6 = preload("uid://bn1f0rtldnfim")
const CONFIGURATION_7 = preload("uid://i4ipe3nbnokp")
const CONFIGURATION_8 = preload("uid://bdsvn8rkt103x")
const CONFIGURATION_9 = preload("uid://bew2yifbtjayj")
const CONFIGURATION_10 = preload("uid://dvpfvl31u5jcc")

#wave 2 configurations
const CONFIGURATION_11 = preload("uid://cn06brsxrr3c1")
const CONFIGURATION_12 = preload("uid://scvvluai3rat")
const CONFIGURATION_13 = preload("uid://btw0k5xilne6q")
const CONFIGURATION_14 = preload("uid://de0vxv202b5ws")
const CONFIGURATION_15 = preload("uid://c8pkrioylh7rv")
const CONFIGURATION_16 = preload("uid://dofk5vo0fyveh")
const CONFIGURATION_17 = preload("uid://jcbajmi5jl5r")
const CONFIGURATION_18 = preload("uid://6yfpm7ibx8md")
const CONFIGURATION_19 = preload("uid://guq66q8sxg52")
const CONFIGURATION_20 = preload("uid://vvfort5s5nev")


#wave 3
const CONFIGURATION_21 = preload("uid://drxg07qb41j1y")
const CONFIGURATION_22 = preload("uid://d1gdwaq3owal6")
const CONFIGURATION_23 = preload("uid://dqraedegkmmq2")
const CONFIGURATION_24 = preload("uid://dsblk2jlovthf")
const CONFIGURATION_25 = preload("uid://ba3qgw4g3pbl6")
const CONFIGURATION_26 = preload("uid://bf2gxkabuytnt")
const CONFIGURATION_27 = preload("uid://dc82hv3xe4tkh")
const CONFIGURATION_28 = preload("uid://bt5l0si0b3awo")
const CONFIGURATION_29 = preload("uid://wbsbmsp5j8xf")
const CONFIGURATION_30 = preload("uid://d28y8dd7w1rje")


var wave_1_configurations : Array[Dictionary] = [
	{"scene": CONFIGURATION_1, "weight": 4},
	{"scene": CONFIGURATION_2, "weight": 5},
	{"scene": CONFIGURATION_3, "weight": 2},
	{"scene": CONFIGURATION_4, "weight": 1},
	{"scene": CONFIGURATION_5, "weight": 2},
	{"scene": CONFIGURATION_6, "weight": 3},
	{"scene": CONFIGURATION_7, "weight": 5},
	{"scene": CONFIGURATION_8, "weight": 4},
	{"scene": CONFIGURATION_9, "weight": 1},
	{"scene": CONFIGURATION_10, "weight": 1},
]

var wave_2_configurations : Array[Dictionary] = [
	{"scene": CONFIGURATION_1, "weight": 2},
	{"scene": CONFIGURATION_2, "weight": 2},
	{"scene": CONFIGURATION_3, "weight": 2},
	{"scene": CONFIGURATION_11, "weight": 4},
	{"scene": CONFIGURATION_12, "weight": 3},
	{"scene": CONFIGURATION_13, "weight": 5},
	{"scene": CONFIGURATION_14, "weight": 3},
	{"scene": CONFIGURATION_15, "weight": 2},
	{"scene": CONFIGURATION_16, "weight": 3},
	{"scene": CONFIGURATION_17, "weight": 2},
	{"scene": CONFIGURATION_18, "weight": 4},
	{"scene": CONFIGURATION_19, "weight": 2},
	{"scene": CONFIGURATION_20, "weight": 1},
]

var wave_3_configurations : Array[Dictionary] = [
	{"scene": CONFIGURATION_3, "weight": 2},
	{"scene": CONFIGURATION_4, "weight": 2},
	{"scene": CONFIGURATION_1, "weight": 2},
	{"scene": CONFIGURATION_21, "weight": 3},
	{"scene": CONFIGURATION_22, "weight": 2},
	{"scene": CONFIGURATION_23, "weight": 5},
	{"scene": CONFIGURATION_24, "weight": 2},
	{"scene": CONFIGURATION_25, "weight": 1},
	{"scene": CONFIGURATION_26, "weight": 4},
	{"scene": CONFIGURATION_27, "weight": 3},
	{"scene": CONFIGURATION_28, "weight": 5},
	{"scene": CONFIGURATION_29, "weight": 2},
	{"scene": CONFIGURATION_30, "weight": 2},
]

func pick_weighted_config(config_list: Array) -> PackedScene:
	var total_weight := 0
	for entry in config_list:
		total_weight += entry["weight"]
	
	var roll := randi_range(1, total_weight)
	var cumulative := 0
	
	for entry in config_list:
		cumulative += entry["weight"]
		if roll <= cumulative:
			return entry["scene"]
	
	return null # should never hit if weights are valid
