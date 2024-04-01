extends RigidBody2D

@onready var audio_player_engine = $AudioStreamPlayer2D_Engine
@onready var audio_player_cannon = $AudioStreamPlayer2D_Cannon
@onready var audio_player_collision = $AudioStreamPlayer2D_Collision
@onready var camera = $Camera2D
@onready var pixelation = $CanvasLayer/Pixelation

@export var max_health = 1000
@export var max_speed = 500
@export var acceleration = 5000
@export var rotation_speed = 2.5
@export var bullet_speed = 1500
@export var fire_rate = 1.0
@export var zoom_speed = 2.5
@export var min_zoom = 1.0 # zooming out
@export var max_zoom = 1.5 # zooming in
@export var pixel_size = 16.0

var collision_sounds = [
	preload("res://Sounds/space_impact.wav"),
	preload("res://Sounds/space_impact2.wav"),
	preload("res://Sounds/space_impact3.wav")
]
var target_zoom_level = 1.0
var health = max_health
var zoom_level = 1.0
var can_fire = true
var bullet = preload("res://Scenes/bullet.tscn")
var collision_particles = preload("res://Scenes/collisionParticles.tscn")

func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health
	audio_player_engine.connect("finished", Callable(self, "_on_loop_sound").bind(audio_player_engine))
	audio_player_engine.play()
	
func _process(delta):
	if pixel_size > 3.0:
		pixelate(delta)
	zoom_level = lerp(zoom_level, target_zoom_level, delta * zoom_speed)
	camera.zoom = Vector2(zoom_level, zoom_level)

func _physics_process(delta):
	handle_rotation(delta)
	handle_movement(delta)
	update_audio_pitch()
	check_fire_input()

func pixelate(delta):
	pixelation.get_material().set_shader_parameter("pixel_size", pixel_size)
	pixel_size -= delta * 4
	if pixel_size <= 5.0:
		pixel_size = 5.0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom_level += 0.1
			target_zoom_level = clamp(target_zoom_level, min_zoom, max_zoom)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom_level -= 0.1
			target_zoom_level = clamp(target_zoom_level, min_zoom, max_zoom)

func handle_rotation(delta):
	var rotation_dir = 0.0
	if Input.is_action_pressed("ui_a"):
		rotation_dir -= 1
	if Input.is_action_pressed("ui_d"):
		rotation_dir += 1
	rotation += rotation_dir * rotation_speed * delta


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

func check_fire_input():
	if Input.is_action_pressed("ui_accept") and can_fire:
		fire_bullet()

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

func _on_loop_sound(player):
	player.stream_paused = false
	player.play()

func update_audio_pitch():
	var min_pitch = 1.0
	var max_pitch = 2.0
	var pitch_range = max_pitch - min_pitch
	var speed_percent = linear_velocity.length() / max_speed
	audio_player_engine.pitch_scale = min_pitch + pitch_range * speed_percent
	
func play_random_collision_sound():
	var random_index = randi() % collision_sounds.size()  # Pick a random index
	audio_player_collision.stream = collision_sounds[random_index]  # Set the stream to a random sound
	audio_player_collision.play()  # Play the sound
	
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
		$HealthBar.value = health
		print("Health:", health)

		# Instantiate and add the particle system
		var particles_instance = collision_particles.instantiate()
		if is_instance_valid(particles_instance):
			particles_instance.global_position = self.global_position  # Position the particles at the contact point or adjust as needed
			get_tree().root.add_child(particles_instance)
			particles_instance.emitting = true  # Start emitting particles

		if health <= 0:
			queue_free()
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")


