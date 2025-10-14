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
		"spawn_time":3, #in seconds
		"config list": wave_1_configurations,
		"cut_scene": null #this plays at the end of the wave?
	},
	
	1 : {
		"time": 180,
		"starting config amount": 1,
		"stagger_time":2,
		"spawn_time":1.8, #in seconds
		"config list": wave_2_configurations,
		"cut_scene": null,
	},
	
	2 : {
		"time": 240,
		"starting config amount": 2,
		"stagger_time":3,
		"spawn_time":1.8, #in seconds
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


var wave_1_configurations : Array[PackedScene] = [
	CONFIGURATION_1,
	CONFIGURATION_2,
	CONFIGURATION_3,
	CONFIGURATION_4,
	CONFIGURATION_5,
	CONFIGURATION_6,
	CONFIGURATION_7,
	CONFIGURATION_8,
	CONFIGURATION_9,
	CONFIGURATION_10
]

var wave_2_configurations : Array[PackedScene] = [
	CONFIGURATION_1, 
	CONFIGURATION_2, 
	CONFIGURATION_3,
	CONFIGURATION_11,
	CONFIGURATION_12,
	CONFIGURATION_13,
	CONFIGURATION_14,
	CONFIGURATION_15,
	CONFIGURATION_16,
	CONFIGURATION_17,
	CONFIGURATION_18,
	CONFIGURATION_19,
	CONFIGURATION_20
]


var wave_3_configurations : Array[PackedScene] = [
	CONFIGURATION_3,
	CONFIGURATION_4,
	CONFIGURATION_1, 
	CONFIGURATION_22,
	CONFIGURATION_23,
	CONFIGURATION_24,
	CONFIGURATION_25,
	CONFIGURATION_26,
	CONFIGURATION_27,
	CONFIGURATION_28,
	CONFIGURATION_29,
	CONFIGURATION_30
]
