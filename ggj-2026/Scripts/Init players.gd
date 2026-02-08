extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player_data in Game.players_data:
		
		var player = Game.PLAYER.instantiate()
		add_child(player)
		player.device_index = player_data["idx"]
		
		player.global_position = Game.get_random_coord()
		
		player.load_skin(player_data["id_skin"])
		
		#print("skin loaded")
		#print(Game.get_player_data_by_index(device_index))
		#print(player.global_position)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
