extends Node3D

var dir_path := "res://Entities/Rooms/Set1"
var rotatable := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir := DirAccess.open(dir_path)
	if not dir:
		return
	
	var scenes: Array[String] = []
	for f in dir.get_files():
		if f.ends_with(".tscn"):
			scenes.append(f)

	if scenes.is_empty():
		return
	
	var file = scenes[randi() % scenes.size()]
	var path = self.dir_path + "/" + file
	var packed := load(path) as PackedScene
	
	if packed:
		var inst : Node3D = packed.instantiate()
		add_child(inst)
	
	if self.rotatable and randi() % 2 == 0:
		# Rotate
		rotate(Vector3.UP, PI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
