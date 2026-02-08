extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player_data in Game.players_data:
		
		var player = Game.PLAYER.instantiate()
		
		player.device_index = player_data["idx"]
		player.global_position = Game.get_random_coord()
		print(player.global_position)
		add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
