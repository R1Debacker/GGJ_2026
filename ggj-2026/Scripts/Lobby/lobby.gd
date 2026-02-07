extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		
func start():
	get_tree().change_scene_to_file("res://Stages/map_Max_test.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for device_idx in range(Game.MAX_PLAYER):
		if device_idx in Game.players_idx:
			continue
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_A):
			Game.players_idx.append(device_idx)
			var player = Game.PLAYER.instantiate()
			add_child(player)
			player.global_position = Game.get_random_coord()
			
			for i in range(10):
				print(Game.get_random_coord())
			
			player.device_index = device_idx
			Game.players.append(player)

	for device_idx in Game.players_idx:
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_START):
			start()
