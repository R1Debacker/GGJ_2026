extends Node

# 1. On remplace les chemins (String) par les scènes réelles (PackedScene).
# Dans l'inspecteur, glissez tous vos fichiers de Rooms dans ce tableau.
@export var room_scenes: Array[PackedScene] = []

func _ready() -> void:
	# Sécurité : Si on a oublié de remplir le tableau
	if room_scenes.is_empty():
		print("ERREUR : Aucune scène n'a été assignée dans le tableau 'room_scenes' !")
		return
	
	var pickable_scenes: Array[PackedScene] = []
	var rooms = get_rooms()
	
	for room in rooms:
		if pickable_scenes.size() == 0:
			pickable_scenes = room_scenes.duplicate()
		
		var idx = randi_range(0, pickable_scenes.size() - 1)
		# On récupère directement la ressource PackedScene, plus besoin de load()
		var selected_scene = pickable_scenes.pop_at(idx)
		
		# 2. On envoie la scène directement
		room.instanciate(selected_scene)

func get_rooms() -> Array[RandomInstance]:
	var rooms: Array[RandomInstance] = []
	for room in get_children():
		if room is RandomInstance:
			rooms.append(room)
	return rooms 

# La fonction get_scenes() est supprimée car elle n'est plus nécessaire.
