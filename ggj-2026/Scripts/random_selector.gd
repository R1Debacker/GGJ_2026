extends Node3D

@export var dir_paths := ["Entities/Rooms/Set1"]
@export var rotatable := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scenes: Array[String] = []
	for dir_path in dir_paths:
		var dir := DirAccess.open("res://" + dir_path)
		if not dir:
			return
		
		for f in dir.get_files():
			if f.ends_with(".tscn"):
				scenes.append(dir_path + "/" + f)

	if scenes.is_empty():
		return
	
	var file = scenes[randi() % scenes.size()]
	var packed := load(file) as PackedScene
	
	if packed:
		var inst : Node3D = packed.instantiate()
		add_child(inst)
	
	if self.rotatable and randi() % 2 == 0:
		# Rotate
		rotate(Vector3.UP, PI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
