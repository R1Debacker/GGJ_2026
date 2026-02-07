extends CharacterBody3D
class_name player3D_top_view

@export var global_speed = 7.0
@export var speed_rotation = 10.0
@export var sprint_factor = 2
#@export var acceration = 4.0
#@export var jump_speed = 8.0

#var jumping = false
#var grounded = true
var last_direction := Vector3.ZERO
var sprinting := false
var can_sprint := true
var speed = global_speed

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

func get_move_input(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var sprinting = Input.is_action_pressed("top_view_sprint") and can_sprint
	var dir_z = Input.get_axis("top_view_move_down","top_view_move_up") * Vector3.FORWARD
	var dir_x = Input.get_axis("top_view_move_left","top_view_move_right") * Vector3.RIGHT
	
	var direction = (dir_z + dir_x)
	var magnitude = direction.length()
	direction = direction.normalized()
	
	anim_tree.set("parameters/IDLE-WALK-RUN/blend_position", magnitude)
	
	if sprinting:
		animation_player.speed_scale = 2.0
		if Input.is_action_just_pressed("top_view_sprint"):
			sprint_duration.start()
		speed = global_speed * sprint_factor
	else:
		speed = global_speed
		animation_player.speed_scale = 1.5
	
	if direction != Vector3.ZERO:
		last_direction = direction
		
	velocity.x = direction.x * speed * magnitude
	velocity.z = direction.z * speed * magnitude
	
	#rotation = transform.looking_at(position + direction).basis.get_euler()
	if rotation.y != transform.looking_at(position + last_direction).basis.get_euler().y:
		rotation.y = rotate_toward(rotation.y,transform.looking_at(position + last_direction).basis.get_euler().y, delta * speed_rotation)
	
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)

	if Input.is_action_just_released("top_view_sprint") and can_sprint:
		sprint_duration.stop()
		can_sprint = false
		sprint_cooldown.start()

func _on_sprint_duration_timeout() -> void:
	can_sprint = false
	sprint_cooldown.start()


func _on_sprint_cooldown_timeout() -> void:
	can_sprint = true
