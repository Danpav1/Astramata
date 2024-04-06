extends RigidBody2D

@onready var camera = $Camera2D
@onready var weapon = $WeaponComponent

var max_speed = 500
var acceleration = 5000
var rotation_speed = 2.5

func _physics_process(delta):
	handle_rotation(delta)
	handle_movement(delta)
	
	if Input.is_action_pressed("ui_space"):
		$WeaponComponent.shoot()

# Checks for correct input & Handles the rotation of our player
func handle_rotation(delta):
	var rotation_dir = 0.0
	if Input.is_action_pressed("ui_a"):
		rotation_dir -= 1
	if Input.is_action_pressed("ui_d"):
		rotation_dir += 1
	rotation += rotation_dir * rotation_speed * delta

# Checks for correct input & Handles the movement of our player
func handle_movement(delta):
	var thrust = 0.0
	if Input.is_action_pressed("ui_w"):
		thrust = acceleration

	# Apply thrust as an impulse
	var thrust_vector = Vector2(thrust, 0).rotated(rotation)
	apply_central_impulse(thrust_vector)

	# Cap the maximum velocity
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
