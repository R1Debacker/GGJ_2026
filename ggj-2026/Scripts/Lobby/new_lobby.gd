extends Node3D

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

		if device_idx < len(Game.players_data):
			continue

		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_A):

			Game.players_data.append({"idx":device_idx,"id_skin":0,"robber":false,"score":0})
			var player = Game.PLAYER.instantiate()

			add_child(player)
			player.device_index = device_idx
			player.position = Game.get_random_coord()/4

	for player_data in Game.players_data:
		var device_idx = player_data["idx"]
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_START):
			start()
		
