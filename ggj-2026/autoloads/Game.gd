extends Node

var WIN_SCORE: float = 100
var fps_player : FpsPlayer = null
const PLAYER = preload("res://Entities/Player/top_view_3d_player.tscn")
var turn :int =0
var list_room_centers : Array[Vector3] = [
	Vector3(-32, 0.5, -18),
	Vector3(0, 0.5, -18),
	Vector3(32, 0.5, -18),
	Vector3(-32, 0.5, 0),
	Vector3(32, 0.5, 0),
	Vector3(-32, 0.5, 18),
	Vector3(0, 0.5, 18),
	Vector3(32, 0.5, 18),
]

var players_data : Array[Dictionary] = []

var nb_players : int :
	get:
		return players_data.size()

const MAX_PLAYER := 10

func get_player_data_by_index(index: int) -> Dictionary:
	for player_data in self.players_data:
		if player_data['idx'] == index:
			return player_data
	return {}

func is_invalid_position(pos: Vector3) -> bool:
	var in_area = pos.x > -20 and pos.x < 20 and pos.z > -12 and pos.z < 12
	var blocked_x = pos.x in [-16, 16]
	var blocked_z = pos.z in [-9, 9]
	return in_area or blocked_x or blocked_z

func get_random_coord() -> Vector3:
	
	var ran_coord = Vector3(0,0.5,0)
	while is_invalid_position(ran_coord):
		ran_coord.x = randi_range(-44, 44)
		ran_coord.z = randi_range(-23, 23)
		
	return ran_coord

func _compare_scores_desc(a: Dictionary, b: Dictionary) -> int:
	if a["score"] > b["score"]:
		return -1
	elif a["score"] < b["score"]:
		return 1
	return 0

func get_rank_players_data():
	var ranked_player_data = players_data.duplicate()
	ranked_player_data.sort_custom(_compare_scores_desc)
	return ranked_player_data

func stop_game():
	get_tree().change_scene_to_file("res://Stages/endgame_lobby.tscn")

func start_lobby():
	get_tree().change_scene_to_file("res://Stages/new_lobby.tscn")
