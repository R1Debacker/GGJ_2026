class_name FpsPlayer
extends CharacterBody3D

@onready var animation_head_bob: AnimationPlayer = %AnimationHeadBob

@export var device_index := 0
@export var speed: float = 5.0
@export var sensitivity: float = 0.003
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8
@export var push_force = 1.0

var device_idx
var head: Node3D
var pitch: float = 0
var grabbed := false
var target_robber := Vector3.ZERO


func _ready() -> void:
	Game.fps_player = self
	head = $Head
	animation_head_bob.play("headbob")

func _physics_process(delta: float) -> void:
	var forward = -transform.basis.z
	var right = transform.basis.x
	
	var direction = Vector3.ZERO
	
	if grabbed:
		velocity = Vector3.ZERO
		rotation.y = transform.looking_at(target_robber).basis.get_euler().y
	else:
		# rotation horizontale du corps
		var x_rotation = -Input.get_joy_axis(device_index, JOY_AXIS_RIGHT_X)
		if abs(x_rotation) <= 0.3: x_rotation = 0
		rotate_y(x_rotation * sensitivity)
		# rotation verticale de la tête
		var y_rotation = -Input.get_joy_axis(device_index, JOY_AXIS_RIGHT_Y)
		if abs(y_rotation) <= 0.3: y_rotation = 0
		pitch = clamp(pitch + y_rotation  * sensitivity, deg_to_rad(-30), deg_to_rad(30))
		head.rotation.x = pitch
		
		var x_direction = -Input.get_joy_axis(device_index, JOY_AXIS_LEFT_Y) * forward
		var z_direction = Input.get_joy_axis(device_index, JOY_AXIS_LEFT_X) * right
		direction = x_direction + z_direction
		var magnitude = direction.length()
		if magnitude <= 0.3: direction = Vector3.ZERO

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
	elif Input.is_joy_button_pressed(device_index, JOY_BUTTON_A):
		velocity.y = jump_velocity

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		# On vérifie si l'objet touché est un RigidBody
		if collision.get_collider() is RigidBody3D:
			var body = collision.get_collider()
			
			var push_dir = -collision.get_normal()
			push_dir.y = 0 
			push_dir = push_dir.normalized()
			
			body.apply_central_impulse(push_dir * push_force)
