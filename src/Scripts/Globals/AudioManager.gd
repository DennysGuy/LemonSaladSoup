extends Node

#weapons
const PISTOLDRY_1 = preload("uid://beq2nhf6oao5r")
const PISTOLDRY_2 = preload("uid://074bdvixjdlh")
const PISTOLDRY_3 = preload("uid://oitkpnkg7qj2")

const RIFLE_1 = preload("uid://boldsopsg0yd1")
const RIFLE_2 = preload("uid://ckkvl43jlwubx")
const RIFLE_3 = preload("uid://bm3scb2c7c7b7")
const RIFLE_4 = preload("uid://c3xrf4k5lcsdm")

const MAINAMBIENT = preload("uid://1lxghv1yxlnx")

const BOSSFALL = preload("uid://bmeban2paw0mi")

const PISTOL_RELOAD_EDIT_1 = preload("uid://c5sybff6nu4ki")
const RIFLEDRAWDRY = preload("uid://b30x564x3r1x1")
const RIFLEHOLSTERDRY = preload("uid://bra2jehmy1oig")
const PISTOLDRAWDRY = preload("uid://c46i3dvh84crq")
const PISTOLHOLSTERDRY = preload("uid://byxiykrvavkfg")

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

const HEADSHOT_1 = preload("uid://g6hygnwxcdja")
const HEADSHOT_2 = preload("uid://bci8uytfvkwpv")
const HEADSHOT_3 = preload("uid://dmm0kj77faaw8")


const COMBOEND = preload("uid://d4huy0s6v3lnn")
const COMBOSTART = preload("uid://daodj3c1e4i2e")
const LOOKLEFT = preload("uid://cii8dkaey6eju")
const LOOKRIGHT = preload("uid://m5f4tqm3hfv5")

const POINTINCREASE = preload("uid://t1normcgnmqr")


const ROUNDSTART = preload("uid://bl8vq57n8287y")


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

func randomize_pitch() -> float:
	return randf_range(0.5,0.7)	
