extends CharacterBody3D

enum State { run, walk, jump, crawl }
var current_state = State.walk

@export var inventory = Node

@onready var collider = $CollisionShape3D
@onready var camera = $CollisionShape3D/Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	change_state(State.walk)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * Constant.mouse_sensitivity)
		camera.rotate_x(-event.relative.y * Constant.mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func change_state(state): 
	current_state = state
	match state:
		State.walk:
			speed = Constant.player_walk_speed
			collider.shape.height = 1.75
		State.run:
			speed = Constant.player_run_speed
			collider.shape.height = 1.75
		State.jump:
			velocity.y = Constant.player_jump_velocity
		State.crawl:
			collider.shape.height = Constant.player_crawl_height
			speed = Constant.player_crawl_speed
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		change_state(State.jump)

	if Input.is_action_pressed('run'):
		change_state(State.run)
	if Input.is_action_just_released('run'):
		change_state(State.walk)

	if Input.is_action_pressed("crawl"):
		change_state(State.crawl)
	if Input.is_action_just_released("crawl"):
		change_state(State.walk)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
