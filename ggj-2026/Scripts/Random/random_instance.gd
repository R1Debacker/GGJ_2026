extends Node3D
class_name RandomInstance

@export var rotatable := true

func instanciate(scene_path):
	var packed := load(scene_path) as PackedScene
	
	if packed:
		var inst : Node3D = packed.instantiate()
		add_child(inst)
	
	if self.rotatable and randi() % 2 == 0:
		# Rotate
		rotate(Vector3.UP, PI)
