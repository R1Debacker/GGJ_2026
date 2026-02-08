extends Node3D

# Au lieu de chemins de dossiers, on utilise une liste de scènes prêtes à l'emploi.
# Glissez tous vos murs ici dans l'inspecteur.
@export var wall_scenes: Array[PackedScene] = []
@export var rotatable := true

func _ready() -> void:
	# Sécurité
	if wall_scenes.is_empty():
		return
	
	# pick_random() est une fonction native de Godot 4 (plus propre que randi % size)
	var selected_scene = wall_scenes.pick_random()
	
	var inst : Node3D = selected_scene.instantiate()
	add_child(inst)
	
	if rotatable and randi() % 2 == 0:
		rotate(Vector3.UP, PI)
