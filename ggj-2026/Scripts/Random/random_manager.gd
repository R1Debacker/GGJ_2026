extends Node

@export var dir_paths := ["Entities/Rooms/Set1"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene_paths = get_scenes()
	var pickable_scene_paths: Array[String] = []
	
	if scene_paths.is_empty():
		return
	var rooms = get_rooms()
	
	for room in rooms:
		if pickable_scene_paths.size() == 0:
			pickable_scene_paths = scene_paths.duplicate()
		
		var idx = randi_range(0, pickable_scene_paths.size() - 1)
		var scene_path = pickable_scene_paths.pop_at(idx)
		room.instanciate(scene_path)

func get_rooms() -> Array[RandomInstance]:
	var rooms: Array[RandomInstance]
	for room in get_children():
		if room is RandomInstance:
			rooms.append(room)
	return rooms 

func get_scenes() -> Array[String]:
	var scene_paths: Array[String] = []
	for dir_path in dir_paths:
		var dir := DirAccess.open("res://" + dir_path)
		if not dir:
			continue
		
		for f in dir.get_files():
			if f.ends_with(".tscn"):
				scene_paths.append(dir_path + "/" + f)
	return scene_paths
