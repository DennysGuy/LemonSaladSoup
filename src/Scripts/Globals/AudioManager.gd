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

const ATTACKHIT_1 = preload("uid://bc84c22dxh5wl")
const ATTACKHIT_2 = preload("uid://bbfcmh67m4cy7")
const ATTACKHIT_3 = preload("uid://cawfiak5qivx4")
const ATTACKHIT_4 = preload("uid://bn5atswy1gpc")
const ATTACKHIT_5 = preload("uid://8di1es7421wy")
const ATTACKHIT_6 = preload("uid://b1qen1i8antxq")
const ATTACKSWIPE_1 = preload("uid://bqaaljnxa2i4j")
const ATTACKSWIPE_2 = preload("uid://dtjjjft3dbq5k")
const ATTACKSWIPE_3 = preload("uid://bqr5slayjr6xv")
const ATTACKSWIPE_4 = preload("uid://cwci6xlpyviop")
const ATTACKSWIPE_5 = preload("uid://drwnelamkdm1v")
const CANNON = preload("uid://cms2ehwe1e7oa")

const SHOOTERDEATH_1 = preload("uid://bsp3ajtv5i6oh")
const SHOOTERDEATH_2 = preload("uid://bgt24up0qy0hy")
const SHOOTERDEATH_3 = preload("uid://8obg0yuapyyr")


@onready var attack_hits : Array[AudioStream] = [ATTACKHIT_1,ATTACKHIT_2,ATTACKHIT_3,ATTACKHIT_4,ATTACKHIT_5,ATTACKHIT_6]
@onready var attack_swipes : Array[AudioStream] = [ATTACKSWIPE_1,ATTACKSWIPE_2,ATTACKSWIPE_3,ATTACKSWIPE_4,ATTACKSWIPE_5]
@onready var shooter_deaths : Array[AudioStream] = [SHOOTERDEATH_1,SHOOTERDEATH_2,SHOOTERDEATH_3]
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

#VOX PROCESSED
const VOX_ANNOUNCER_ALERT__BEHIND_01 = preload("uid://gjvmgnakqhp3")
const VOX_ANNOUNCER_ALERT__BEHIND_02 = preload("uid://cx5bqijuvdaw4")
const VOX_ANNOUNCER_ALERT__BEHIND_03 = preload("uid://cg01uw04f0fmm")
const VOX_ANNOUNCER_ALERT__LEFT_01 = preload("uid://1v047hv23e0m")
const VOX_ANNOUNCER_ALERT__LEFT_02 = preload("uid://b2jea31hvlv54")
const VOX_ANNOUNCER_ALERT__LEFT_03_1_ = preload("uid://cnki240i26kcu")
const VOX_ANNOUNCER_ALERT__LEFT_03 = preload("uid://dcr0eqpycmvkg")
const VOX_ANNOUNCER_ALERT__RELOAD_01 = preload("uid://bqya5q8munxdb")
const VOX_ANNOUNCER_ALERT__RIGHT_01 = preload("uid://catwlks58hslx")
const VOX_ANNOUNCER_ALERT__RIGHT_02 = preload("uid://dlyselcmfel0")
const VOX_ANNOUNCER_ALERT__RIGHT_03 = preload("uid://bhut5u0ulgnym")
const VOX_ANNOUNCER_COUNT_DOWN__FIVE_01 = preload("uid://h27uj2lrqw3y")
const VOX_ANNOUNCER_COUNT_DOWN__FOUR_01 = preload("uid://bc6fiq6ixl8cw")
const VOX_ANNOUNCER_COUNT_DOWN__FULL_01 = preload("uid://5qwcdbvjj46y")
const VOX_ANNOUNCER_COUNT_DOWN__ONE_01 = preload("uid://cndbsqw5k111e")
const VOX_ANNOUNCER_COUNT_DOWN__SURVIVE_01 = preload("uid://fi5tr5hfesed")
const VOX_ANNOUNCER_COUNT_DOWN__THREE_01 = preload("uid://dn6m38cdhfle")
const VOX_ANNOUNCER_COUNT_DOWN__TWO_01 = preload("uid://tc7hd8e0cr0m")
const VOX_ANNOUNCER_FIRST_BLOOD_01 = preload("uid://5q4md6ksqd1d")
const VOX_ANNOUNCER_GAME_STATUS_OVER_01 = preload("uid://cp6e5uxxqixe4")
const VOX_ANNOUNCER_GAME_STATUS_WIN_01 = preload("uid://cnt4ap3h2bj56")
const VOX_ANNOUNCER_LEMON_SALAD_SOUP_01 = preload("uid://qabpdfxiy1oe")
const VOX_ANNOUNCER_LEMON_SALAD_SOUP_02 = preload("uid://b2722oe4knsa3")
const VOX_ANNOUNCER_LEMON_01 = preload("uid://pt33atla67q6")
const VOX_ANNOUNCER_LEMON_02 = preload("uid://c23ssbwa1u4s")
const VOX_ANNOUNCER_SALAD_01 = preload("uid://bk57d4acygsuj")
const VOX_ANNOUNCER_SALAD_02 = preload("uid://cemxev4o370vk")
const VOX_ANNOUNCER_SHOT_HEAD_SHOT_01 = preload("uid://cp2lkuyq1npx4")
const VOX_ANNOUNCER_SHOT_HEAD_SHOT_02 = preload("uid://bn0pciyyqnf5t")
const VOX_ANNOUNCER_SHOT_HEAD_SHOT_03 = preload("uid://lhyoys4b03ue")
const VOX_ANNOUNCER_SHOT_MISS_01 = preload("uid://boop2rwxpavad")
const VOX_ANNOUNCER_SHOT_MISS_02 = preload("uid://bxxmmwjhpp6g3")
const VOX_ANNOUNCER_SHOT_MISS_03 = preload("uid://no5eplufd2lw")
const VOX_ANNOUNCER_SHOT_PERFECT_01 = preload("uid://bpytm8b6ihywr")
const VOX_ANNOUNCER_SHOT_PERFECT_02 = preload("uid://bigq28y87wori")
const VOX_ANNOUNCER_SHOT_PERFECT_03 = preload("uid://bkphwoxxovgmc")
const VOX_ANNOUNCER_SOUP_01 = preload("uid://bnq820c6hu2am")
const VOX_ANNOUNCER_SOUP_02 = preload("uid://d1s6k4eyv6ghc")
const VOX_BOSS_DEATH_CRY_01 = preload("uid://buouppmgh67a7")
const VOX_BOSS_DEATH_CRY_02 = preload("uid://sq3522b57nfe")
const VOX_BOSS_DEATH_CRY_03 = preload("uid://bi71cscfplrlk")
const VOX_BOSS_DIALOGUE_BLASPHEMY_01 = preload("uid://bhb702e2yusy")
const VOX_BOSS_DIALOGUE_BLASPHEMY_02 = preload("uid://brs4vmyt6rwpa")
const VOX_BOSS_DIALOGUE_BLASPHEMY_03 = preload("uid://bjiexx1ilbumr")
const VOX_BOSS_DIALOGUE_BLASPHEMY_04 = preload("uid://dxm3py2iad5bg")
const VOX_BOSS_DIALOGUE_DEFEAT_01 = preload("uid://dib8766hlh61v")
const VOX_BOSS_DIALOGUE_DEFEAT_02 = preload("uid://s8gao2xwon57")
const VOX_BOSS_DIALOGUE_INTRO_01 = preload("uid://he2ao0n15tqn")
const VOX_BOSS_DIALOGUE_INTRO_02 = preload("uid://cbpyn3ugvk7ce")
const VOX_BOSS_LAUGH_01 = preload("uid://uq1jld5qjonl")
const VOX_BOSS_LAUGH_02 = preload("uid://b4de2h351cn6m")
const VOX_BOSS_LAUGH_03 = preload("uid://boac1y7x4obhr")
const VOX_BOSS_LAUGH_04 = preload("uid://t3txogsib2pb")

#UI
const UI_GAME_START_01 = preload("uid://vrgv6ldwnay4")
const UI_HOVER_01 = preload("uid://mgobvjrkqk2w")
const UI_PRESS_01 = preload("uid://dpkkqbinpnhrg")

const BOSSJUMP = preload("uid://bvpohncnr21k5")
const CROWD_GASP = preload("uid://c2yraqi2h6q31")

const MULTIPLIER = preload("uid://cyd6kljstq3gw")
const MURMUR = preload("uid://dpaaixiqw3wq3")


const COMBOEND = preload("uid://d4huy0s6v3lnn")
const COMBOSTART = preload("uid://daodj3c1e4i2e")
const LOOKLEFT = preload("uid://cii8dkaey6eju")
const LOOKRIGHT = preload("uid://m5f4tqm3hfv5")

const POINTINCREASE = preload("uid://t1normcgnmqr")

const ROUNDSTART = preload("uid://bl8vq57n8287y")

const COUNTDOWN_BEEP = preload("uid://cf6ltpr4suhgh")
const COUNT_DOWN_BEEP_DONE = preload("uid://d0qxh6l38av1f")


#music 
const DEATH_CUTSCENE = preload("uid://slptydpfudn3")
const FIRST_WAVE = preload("uid://cyh3qhqeym6oa")
const SECOND_WAVE = preload("uid://8j3n1nwjbopc")
const START_MENU_THEME_OPTION_1 = preload("uid://dg583ahm87vh3")
const THIRD_WAVE = preload("uid://uce2pdmrwu3")
const WELCOME_TO_THE_ARENA_DIALOGUE_CUTSCENE = preload("uid://d3xiyr5t7laqp")


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



func play_boss_battle_theme() -> void:
	play_music(THIRD_WAVE)

func play_boss_theme() -> void:
	play_music(WELCOME_TO_THE_ARENA_DIALOGUE_CUTSCENE)

func stop_music_player() -> void:
	music_player.stop()

func randomize_pitch() -> float:
	return randf_range(0.5,0.7)	
