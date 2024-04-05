extends RigidBody2D

@onready var audio_player_engine = $AudioStreamPlayer2D_Engine
@onready var audio_player_cannon = $AudioStreamPlayer2D_Cannon
@onready var audio_player_collision = $AudioStreamPlayer2D_Collision
@onready var camera = $Camera2D

signal player_died

var max_health = 100
var max_speed = 500
var acceleration = 5000
var rotation_speed = 2.5
var bullet_speed = 1500
var fire_rate = 1.0
var zoom_speed = 2.5
var min_zoom = 1.0 # zooming out
var max_zoom = 1.5 # zooming in
var pixel_size = 16.0
var min_pitch
var max_pitch
var target_zoom_level = 1.0
var health = max_health
var zoom_level = 1.0
var can_fire = true
var bullet = preload("res://Scenes/Gameplay/Entities/Projectiles/bullet.tscn")
var collision_particles = preload("res://Scenes/Gameplay/Particles/collisionParticles.tscn")
var main_scene = preload("res://Scenes/main.tscn")
var main_instance

var collision_sounds = [
	preload("res://Assets/Sounds/SFX/space_impact.wav"),
	preload("res://Assets/Sounds/SFX/space_impact2.wav"),
	preload("res://Assets/Sounds/SFX/space_impact3.wav")
]

# Called when the scene is first instantiated
func _ready():
	main_instance = main_scene
	audio_player_engine.connect("finished", Callable(self, "_on_loop_sound").bind(audio_player_engine))
	audio_player_engine.play()

# Makes sure we're at the correct pixel size and camera zoom level, called every frame update
# (16 per sec)
func _process(delta):
	check_and_handle_fire()
	zoom_level = lerp(zoom_level, target_zoom_level, delta * zoom_speed)
	camera.zoom = Vector2(zoom_level, zoom_level)

# Called every frame update (16 per sec) and handles all the physics
func _physics_process(delta):
	handle_rotation(delta)
	handle_movement(delta)
	update_audio_pitch()

# Applies pixelate shader
func pixelate(delta):
	pixel_size -= delta * 4
	if pixel_size <= 5.0:
		pixel_size = 5.0

# Event input handler that takes care of scroll wheel zooming
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom_level += 0.1
			target_zoom_level = clamp(target_zoom_level, min_zoom, max_zoom)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom_level -= 0.1
			target_zoom_level = clamp(target_zoom_level, min_zoom, max_zoom)
			
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
		if Input.is_action_pressed("ui_shift"):
			acceleration = 15000
			max_speed = 750
			rotation_speed = 2.0
		else:
			acceleration = 5000
			max_speed = 500
			rotation_speed = 2.5

	# Apply thrust as an impulse
	var thrust_vector = Vector2(thrust, 0).rotated(rotation)
	apply_central_impulse(thrust_vector)

	# Cap the maximum velocity
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

# Checks for and handles our firing
func check_and_handle_fire():
	if Input.is_action_pressed("ui_space") and can_fire:
		fire_bullet()

# handles firing our cannon
func fire_bullet():
	audio_player_cannon.play()
	audio_player_cannon.play()
	
	var bullet_instance1 = bullet.instantiate()
	var bullet_instance2 = bullet.instantiate()
	
	bullet_instance1.position = $BulletPoint.global_position
	bullet_instance2.position = $BulletPoint2.global_position
	
	bullet_instance1.rotation_degrees = rotation_degrees
	bullet_instance2.rotation_degrees = rotation_degrees
	
	bullet_instance1.gravity_scale = 0
	bullet_instance2.gravity_scale = 0
	
	bullet_instance1.linear_velocity = Vector2(bullet_speed, 0).rotated(rotation)
	bullet_instance2.linear_velocity = Vector2(bullet_speed, 0).rotated(rotation)
	
	get_tree().root.add_child(bullet_instance1)
	get_tree().root.add_child(bullet_instance2)
	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

# indefinitely loops whatever audio player is given to it
func _on_loop_sound(player):
	player.stream_paused = false
	player.play()

# increases or decreases the pitch of the engine sound based on our velocity 
func update_audio_pitch():
	min_pitch = 1.0
	max_pitch = 2.0
	var pitch_range = max_pitch - min_pitch
	var speed_percent = linear_velocity.length() / max_speed
	audio_player_engine.pitch_scale = min_pitch + pitch_range * speed_percent

# plays a random sound from the collision_sounds array
func play_random_collision_sound():
	var random_index = randi() % collision_sounds.size()
	# Set the stream to a random sound
	audio_player_collision.stream = collision_sounds[random_index]
	audio_player_collision.play()
	
# Called whenever something touches our collision polygon(s)
func _on_body_entered(body):
	if not is_instance_valid(self) or body.is_in_group("bullet"):
		return
	
	play_random_collision_sound()
	if health > 0:
		var other_velocity = body.get_linear_velocity()
		var relative_velocity = get_linear_velocity() - other_velocity
		var damage = relative_velocity.length()
		health -= damage
		health = floor(health)
		print("Health:", health)

		# Instantiate and add the particle system
		var particles_instance = collision_particles.instantiate()
		if is_instance_valid(particles_instance):
			 # Position the particles at the contact point or adjust as needed
			particles_instance.global_position = self.global_position
			get_tree().root.add_child(particles_instance)
			particles_instance.emitting = true  # Start emitting particles

		if health <= 0:
			emit_signal("player_died")
			
