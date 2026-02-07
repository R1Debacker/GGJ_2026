extends CharacterBody3D
class_name player3D_top_view

@export var device_index := 0
@export var default_speed := 7.0
@export var speed_rotation = 10.0
@export var sprint_factor = 2
@export var push_force = 1.0
@onready var grab_sound: AudioStreamPlayer = $GrabSound
@onready var fail_sound: AudioStreamPlayer = $FailSound
@export var skins : Array[Node3D]
@onready var victory: AudioStreamPlayer = $Victory

#@export var acceration = 4.0
#@export var jump_speed = 8.0

#var jumping = false
#var grounded = true

var last_direction := Vector3.FORWARD
var sprinting := false
var grabbing := false
var success_grab := false
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
	
	if Input.is_joy_button_pressed(device_index, JOY_BUTTON_X):
		grabbing = true
		var vectorToRobber = Game.fps_player.position - position
		var distanceToRobber = vectorToRobber.length()
		var dot = last_direction.dot(vectorToRobber)
		anim_state.travel("Grabbing")
		
		if distanceToRobber <= 4 && dot > -0.2:
			rotation.y = transform.looking_at(Game.fps_player.position).basis.get_euler().y
			position = Game.fps_player.position - vectorToRobber.normalized() * 1.5
			success_grab = true
			Game.fps_player.target_robber = position
			Game.fps_player.grabbed = true
			grab_sound.play()
			await grab_sound.finished
			victory.play()
			Input.start_joy_vibration(device_index, 0.5, 0.5, 0.1) 
		else :
			await get_tree().create_timer(1.0).timeout
			fail_sound.play()
	
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
	if grabbing:
		velocity = Vector3.ZERO
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
	else:
		if Input.get_joy_axis(device_index, JOY_AXIS_TRIGGER_RIGHT) > 0.9 and can_sprint and not sprinting:
			sprinting = true
			sprint_duration.start()
			print("sprint start")
			
		if Input.get_joy_axis(device_index, JOY_AXIS_TRIGGER_RIGHT) < 0.5 and sprinting:
			sprint_duration.stop()
			can_sprint = false
			sprinting = false
			sprint_cooldown.start()
			
		if sprinting:
			speed = sprint_speed
			animation_player.speed_scale = 3.0
			
		var dir_z = -Input.get_joy_axis(device_index, JOY_AXIS_LEFT_Y) * Vector3.FORWARD
		var dir_x = Input.get_joy_axis(device_index, JOY_AXIS_LEFT_X) * Vector3.RIGHT
		
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

func load_skin(index: int):
	for i in skins.size():
		if i == index: skins[i].show()
		else: skins[i].hide()

func _on_sprint_duration_timeout() -> void:
	can_sprint = false
	sprinting = false
	print("not sprint anymore")
	sprint_cooldown.start()

func _on_sprint_cooldown_timeout() -> void:
	can_sprint = true
	print("cooldown end")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Grabbing":
		grabbing = false
		if success_grab:
			success_grab = false
			var fps_index = Game.fps_player.device_index
			Game.fps_player.device_index = device_index
			device_index = fps_index
			position = Game.get_random_coord()
			Game.fps_player.rotate(Vector3.UP, 180)
			Game.fps_player.grabbed = false
