extends Node2D

@export var projectile_scene: PackedScene
var projectile_speed : float
var fire_rate : float
var can_fire = true

func shoot():
	if not can_fire or projectile_scene == null:
		return
	
	var projectile_instance = projectile_scene.instantiate()
	
	projectile_speed = projectile_instance.speed
	fire_rate = projectile_instance.fire_rate
	
	projectile_instance.position = $BulletPoint.global_position

	# Use the global rotation of the player (RigidBody2D)
	var player_rotation_degrees = get_parent().global_rotation_degrees
	projectile_instance.rotation_degrees = player_rotation_degrees
	
	projectile_instance.gravity_scale = 0
	
	# Rotate the velocity vector by the player's global rotation converted to radians
	projectile_instance.linear_velocity = Vector2(projectile_speed, 0).rotated(deg_to_rad(player_rotation_degrees))
	
	get_tree().root.add_child(projectile_instance)
	
	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
