extends Node3D

var players : Array[player3D_top_view]
@onready var label: Label = $CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		
func start():
	get_tree().change_scene_to_file("res://Stages/main_map.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Press A to join the room\n and Start to launch the game"
	
	for device_idx in range(Game.MAX_PLAYER):

		if is_in_datas(device_idx):
			continue

		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_A):
			var player_data = {
				"idx" : device_idx,
				"id_skin" : 0,
				"robber" : false,
				"score" : 0,
				"rob_count": 0,
			}
			Game.players_data.append(player_data)
			var player = Game.PLAYER.instantiate()

			add_child(player)
			player.device_index = device_idx
			player.global_position = Game.get_random_coord()/4
			players.append(player)
			

	for player_data in Game.players_data:
		var device_idx = player_data["idx"]
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_RIGHT_SHOULDER):
			change_skin(device_idx, true)
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_LEFT_SHOULDER):
			change_skin(device_idx, false)
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_START):
			start()
		
func change_skin(device_idx: int, next: bool):
	for player_data in Game.players_data:
		if player_data["idx"] == device_idx:
			for player in players:
				if player.device_index == device_idx:
					if player.can_change_skin:
						if next:
							player_data["id_skin"] = player_data["id_skin"] + 1
						else:
							player_data["id_skin"] = player_data["id_skin"] - 1
						player.load_skin(player_data["id_skin"])
					break

			break
	
func  is_in_datas(device_idx: int) -> bool:
	for player_data in Game.players_data:
		if player_data["idx"] == device_idx:
			return true
	return false
