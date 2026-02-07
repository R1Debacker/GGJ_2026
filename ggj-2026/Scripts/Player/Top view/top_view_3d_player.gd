extends CharacterBody3D
class_name player3D_top_view

@export var speed = 7.0
@export var speed_rotation = 10.0
#@export var acceration = 4.0
#@export var jump_speed = 8.0

#var jumping = false
#var grounded = true
var last_direction := Vector3.ZERO

@onready var model := $Skeleton/Skeleton3D
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")


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
	
	var dir_z = Input.get_axis("top_view_move_down","top_view_move_up") * Vector3.FORWARD
	var dir_x = Input.get_axis("top_view_move_left","top_view_move_right") * Vector3.RIGHT
	
	var direction = (dir_z + dir_x)
	var magnitude = direction.length()
	direction = direction.normalized()
	
	anim_tree.set("parameters/IDLE-WALK-RUN/blend_position", magnitude)
	
	if direction != Vector3.ZERO:
		last_direction = direction
		
	velocity.x = direction.x * speed * magnitude
	velocity.z = direction.z * speed * magnitude
	
	#rotation = transform.looking_at(position + direction).basis.get_euler()
	
	rotation.y = rotate_toward(rotation.y,transform.looking_at(position + last_direction).basis.get_euler().y, delta * speed_rotation)
	
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)
