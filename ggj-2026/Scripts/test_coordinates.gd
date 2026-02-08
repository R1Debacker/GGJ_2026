extends Node3D

@onready var boule: MeshInstance3D = $boule
@onready var top_view_3d_player: player3D_top_view = $"top view 3D Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if Input.is_joy_button_pressed(0,JOY_BUTTON_A):
		top_view_3d_player.position = Game.get_random_coord()
		print("global :")
		print(top_view_3d_player.global_position)
		print("position :")
		print(top_view_3d_player.position)
		if position.y < 5:
			print('CHHHHUUUTE')
			
