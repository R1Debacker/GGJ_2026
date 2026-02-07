extends CharacterBody3D

@onready var animation_head_bob: AnimationPlayer = $Head/AnimationHeadBob
@export var speed: float = 5.0
@export var sensitivity: float = 0.003
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8

var head: Node3D
var pitch: float = 0.0

func _ready() -> void:
	head = $Head
	animation_head_bob.play("headbob")

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO

	var forward = -transform.basis.z
	var right = transform.basis.x
	
	# rotation horizontale du corps
	rotate_y(-Input.get_axis("fps_look_left", "fps_look_right") * sensitivity)
	# rotation verticale de la tête
	pitch = clamp(pitch + Input.get_axis("fps_look_down", "fps_look_up") * sensitivity, deg_to_rad(-89), deg_to_rad(89))
	head.rotation.x = pitch
	
	var x_direction = Input.get_axis("fps_move_back", "fps_move_forward") * forward
	var z_direction = Input.get_axis("fps_move_left", "fps_move_right") * right
	direction = x_direction + z_direction
	var magnitude = direction.length()

	direction = direction.normalized()
	if direction != Vector3.ZERO:
		animation_head_bob.speed_scale = magnitude * 2
	else:
		if animation_head_bob.speed_scale != 0.0:
			animation_head_bob.speed_scale = 0.0
	# mouvement horizontal
	velocity.x = direction.x * speed * magnitude
	velocity.z = direction.z * speed * magnitude

	## gravité et saut
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("fps_jump"):
		velocity.y = jump_velocity

	move_and_slide()
