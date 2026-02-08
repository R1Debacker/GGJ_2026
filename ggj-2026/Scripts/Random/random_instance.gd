extends Node3D
class_name RandomInstance

@export var rotatable := true
@export var flipable_z := true

func instanciate(packed : PackedScene):
	if not packed:
		return
	
	var inst : Node3D = packed.instantiate()
	add_child(inst)
	
	if self.rotatable and randi() % 2 == 0:
		# Rotate
		rotate(Vector3.UP, PI)
	
	if self.flipable_z and randi() % 2 == 0:
		# Flip Z
		var lights = inst.get_node_or_null("Lights")
		if not lights:
			return
		
		lights.reparent(self)
		inst.scale.z = -1
