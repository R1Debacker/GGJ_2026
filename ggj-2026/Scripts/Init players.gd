extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player_data in Game.players_data:
		var player = player3D_top_view.spawn(self, player_data)
		player.global_position = Game.get_random_coord()
