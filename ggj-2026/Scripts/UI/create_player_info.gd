extends HBoxContainer

var PlayerInfo := preload("res://Entities/UI/player_info.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player_data in Game.players_data:
		var player_info = PlayerInfo.instantiate()
		add_child(player_info)
		player_info.device_idx = player_data['idx']
