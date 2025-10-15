extends Node

#weapons
const GRENADEBLOW = preload("uid://bwca28qx6tt2f")
const GRENADETHROW = preload("uid://c8q0mru614t5y")
const PISTOL_1 = preload("uid://c2uarsmul3e8o")
const PISTOL_2 = preload("uid://202w364mk0xf")
const PISTOL_3 = preload("uid://deu7qlwvj8lc2")
const PISTOLDRAW = preload("uid://c7mekx3ab3djv")
const PISTOLHOLSTER = preload("uid://dmx2uq6dehc85")
const PISTOLRELOAD = preload("uid://dlb51yqv3yvet")
const RIFLE_1 = preload("uid://cnv0nxwy0pink")
const RIFLE_2 = preload("uid://b3jvdy4pyjn4x")
const RIFLE_3 = preload("uid://872ogorkxndu")
const RIFLE_4 = preload("uid://oq7fc0c32juf")
const RIFLEDRAW = preload("uid://cjlj2ooj2e5ul")
const RIFLEHOLSTER = preload("uid://dkukngkbbgt46")

#Player
const PLAYERDEATH = preload("uid://r6r3siwn3lbh")
const PLAYERHIT_1 = preload("uid://cnh0442xbgdi8")
const PLAYERHIT_2 = preload("uid://dsujjxawwl2ju")
const PLAYERHIT_3 = preload("uid://dnb4a6wt2trtw")
const PLAYERHIT_4 = preload("uid://cm4m04auy1y03")

@onready var player_hits : Array[AudioStream] = [PLAYERHIT_1, PLAYERHIT_2, PLAYERHIT_3, PLAYERHIT_4]

#Enemies
const ENEMYDEATH_1 = preload("uid://d5cujljoiyja")
const ENEMYDEATH_2 = preload("uid://drb4kv0tbeghb")
const ENEMYDEATH_3 = preload("uid://8r77sd8033gj")
const ENEMYDEATH_4 = preload("uid://e8bdhehd5iyk")
const ENEMYDEATH_5 = preload("uid://brx0ff1itibko")
const ENEMYDEATH_6 = preload("uid://brjdi3dex3dko")
const ENEMYDEATH_7 = preload("uid://dgxey4xctkp4d")
const ENEMYDEATH_8 = preload("uid://fokwhch22weg")
const HEADSHOT_1 = preload("uid://drluwb178jnro")
const HEADSHOT_2 = preload("uid://dnmgrnlrlov0a")
const HEADSHOT_3 = preload("uid://dihrq7csaqg2r")

@onready var enemy_deaths : Array[AudioStream] = [ENEMYDEATH_1,ENEMYDEATH_2,ENEMYDEATH_3,ENEMYDEATH_4,ENEMYDEATH_5,ENEMYDEATH_6,ENEMYDEATH_7,ENEMYDEATH_8]
@onready var head_shots : Array[AudioStream] = [HEADSHOT_1, HEADSHOT_2, HEADSHOT_3]

const MAINAMBIENT = preload("uid://1lxghv1yxlnx")

const BOSSFALL = preload("uid://bmeban2paw0mi")

const BLASPHEMY_PLACE_HOLDER = preload("uid://cwjgcv8veu5m5")
const HOLDER_VOX_ANNOUNCER_HAND_GUN = preload("uid://dwcqgweymtcyl")
const HOLDER_VOX_ANNOUNCER_RIFLE = preload("uid://manaehqar268")
const HOLDER_VOX_ANNOUNCER_SURVIVE = preload("uid://rvk6fcxh7o70")
const HOLDER_VOX_BOSS_FIRST_BLOOD = preload("uid://bojbd68nbqptg")
const HOLDER_VOX_BOSS_INTRO = preload("uid://c4ncnsjxyysxj")
const HOLDER_VOX_BOSS_WIN = preload("uid://6vh5i4sr2frx")
const HOLDER_VOX_ENE_CHARGE_01 = preload("uid://b6sy8smo8n844")
const HOLDER_VOX_ENE_CHARGE_02 = preload("uid://rma34g338og")
const HOLDER_VOX_ENE_DEAD = preload("uid://bblicsf453abd")
const HOLDER_VOX_ENE_GRUNT = preload("uid://bl3swwquit2y7")
const HOLDER_VOX_MIB_REVEAL = preload("uid://dna3co2505gl3")
const HOLDER_VOX_RADIO_BEHIND = preload("uid://cbbi0jm6immtf")
const HOLDER_VOX_RADIO_LEFT = preload("uid://cut5cb0w65efx")
const HOLDER_VOX_RADIO_PRAISE_01 = preload("uid://bduwccig21apf")
const HOLDER_VOX_RADIO_PRAISE_02 = preload("uid://do2u1hjrbopca")
const HOLDER_VOX_RADIO_PRAISE_03 = preload("uid://dnisaafc4vnrp")
const HOLDER_VOX_RADIO_RIGHT = preload("uid://7utdedjjmj77")
const HOLDER_VOX_TITLE_LEMON = preload("uid://cxk1640gki3h0")
const HOLDER_VOX_TITLE_LEMON_SALAD_SOUP = preload("uid://dcs2p56k6i31m")
const HOLDER_VOX_TITLE_SALAD = preload("uid://1gidmsl64s5h")
const HOLDER_VOX_TITLE_SOUP = preload("uid://5ha1fmja7e1d")
const IMPRESSIVE_PLACE_HOLDER = preload("uid://wr51xgy1vgqf")
const MEET_FATE_PLACE_HOLDER = preload("uid://ms0f5d18pu4i")
const MINIONS_TEAR_APART_PLACE_HOLDER = preload("uid://tgkn4npp03rd")
const UNFORGIVABLE_PLACE_HOLDER = preload("uid://b4nts41fh65ly")
const YOU_DARE_PLACEHOLDER = preload("uid://5y3tha3m65v1")




const COMBOEND = preload("uid://d4huy0s6v3lnn")
const COMBOSTART = preload("uid://daodj3c1e4i2e")
const LOOKLEFT = preload("uid://cii8dkaey6eju")
const LOOKRIGHT = preload("uid://m5f4tqm3hfv5")

const POINTINCREASE = preload("uid://t1normcgnmqr")

const ROUNDSTART = preload("uid://bl8vq57n8287y")

#music 
const DEATH_CUTSCENE = preload("uid://bgxbh7l7etfk6")
const FIRST_WAVE_1_1 = preload("uid://c8rt38qcovpij")
const START_MENU_THEME_OPTION_1 = preload("uid://dgldl1dapp7je")
const WELCOME_TO_THE_ARENA__DIALOGUE_CUTSCENE_1_ = preload("uid://cs5qkscs13mik")

@onready var music_player: AudioStreamPlayer = $MusicPlayer


func play_sfx(audio_stream : AudioStream, volume_db : float = 0.0, randomized_pitch : bool = false) -> void:
	var asp : AudioStreamPlayer = AudioStreamPlayer.new()
	asp.stream = audio_stream
	asp.volume_db = volume_db
	
	if randomized_pitch:
		asp.pitch_scale = randomize_pitch()
		
	asp.bus = "SFX"
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()

func play_music(audio_stream : AudioStream, volume_db : float = 0.0) -> void:
	music_player.stream = audio_stream
	music_player.volume_db = volume_db
	music_player.play()

func play_boss_theme() -> void:
	play_music(WELCOME_TO_THE_ARENA__DIALOGUE_CUTSCENE_1_)

func stop_music_player() -> void:
	music_player.stop()

func randomize_pitch() -> float:
	return randf_range(0.5,0.7)	
