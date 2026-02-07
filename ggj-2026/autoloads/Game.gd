extends Node

#@onready var timer: Timer = $Timer
#@onready var menu_button_sound: AudioStreamPlayer2D = $menu_button_sound
#@onready var bubble_pop: AudioStreamPlayer2D = $BubblePop
#@onready var back_sound: AudioStreamPlayer2D = $BackSound
#@onready var ellie: AudioStreamPlayer2D = $Ellie
#@onready var menu_music: AudioStreamPlayer2D = $MenuMusic
#@onready var bubble_pop_petites: AudioStreamPlayer2D = $"Bubble pop petites"
#@onready var sylvain: AudioStreamPlayer2D = $Sylvain
#@onready var beep: AudioStreamPlayer2D = $beep
#@onready var okaaaaay_letsgo: AudioStreamPlayer2D = $OkaaaaayLetsgo
#@onready var souffrir_ok: AudioStreamPlayer2D = $SouffrirOk
#@onready var we_did_it: AudioStreamPlayer2D = $WeDidIt


const PLAYER = preload("res://Entities/Player/top_view_3d_player.tscn")
var turn :int =0

var avail_skin := [1,2,3,4]

var players : Array = []
var players_idx : Array = []
var nb_players : int :
	get:
		return players.size()
const MAX_PLAYER := 10

func get_random_coord() -> Vector3:
	
	var ran_coord = Vector3(0,0,0)
	
	ran_coord.x = randi() % 97
	ran_coord.z = randi() % 55
	while ran_coord.x in [32,64] and ran_coord.z in [18,36]:
		ran_coord.x = randi() % 97
		ran_coord.z = randi() % 55
			
	return ran_coord
	
