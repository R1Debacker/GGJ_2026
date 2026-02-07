extends CharacterBody3D
class_name player3D_top_view

@export var player_index := 0
@export var default_speed := 7.0
@export var speed_rotation = 10.0
@export var sprint_factor = 2
@export var push_force = 1.0

#@export var acceration = 4.0
#@export var jump_speed = 8.0

#var jumping = false
#var grounded = true

var device_idx
var last_direction := Vector3.FORWARD
var sprinting := false
var can_sprint := true
var sprint_speed = default_speed * sprint_factor
var speed

@onready var model := $Skeleton/Skeleton3D
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sprint_duration: Timer = $"Sprint duration"
@onready var sprint_cooldown: Timer = $"Sprint cooldown"


func _ready() -> void:
	anim_tree.active = true

func _physics_process(delta: float):
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	get_move_input(delta)
	
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

func get_move_input(delta):
	
	speed = default_speed
	animation_player.speed_scale = 1.5
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
	if Input.is_action_just_pressed("top_view_sprint") and can_sprint and not sprinting:
		sprinting = true
		sprint_duration.start()
		print("sprint start")
		
	if Input.is_action_just_released("top_view_sprint") and sprinting:
		sprint_duration.stop()
		can_sprint = false
		sprinting = false
		sprint_cooldown.start()
		
	if sprinting:
		speed = sprint_speed
		animation_player.speed_scale = 3.0
		
	var dir_z = -Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y) * Vector3.FORWARD
	var dir_x = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X) * Vector3.RIGHT
	
	var direction = (dir_z + dir_x)
	var magnitude = direction.length()
	if magnitude <= 0.3: direction = Vector3.ZERO
	direction = direction.normalized()
	
	anim_tree.set("parameters/IDLE-WALK-RUN/blend_position", magnitude)	
	
	if direction != Vector3.ZERO:
		last_direction = direction
		
	velocity.x = direction.x * speed * magnitude
	velocity.z = direction.z * speed * magnitude
	
	#rotation = transform.looking_at(position + direction).basis.get_euler()
	if transform.origin != position + last_direction:
		rotation.y = rotate_toward(rotation.y,transform.looking_at(position + last_direction).basis.get_euler().y, delta * speed_rotation)
	
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)


func _on_sprint_duration_timeout() -> void:
	can_sprint = false
	sprinting = false
	print("not sprint anymore")
	sprint_cooldown.start()


func _on_sprint_cooldown_timeout() -> void:
	can_sprint = true
	print("cooldown end")
