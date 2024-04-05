extends RigidBody2D

var explosion = preload("res://Scenes/Gameplay/Entities/Projectiles/bullet_exposion.tscn")

func _on_body_entered(body):
	if !body.is_in_group("player"):
		var explosion_instance = explosion.instantiate()
		explosion_instance.position = get_global_position()
		get_parent().add_child(explosion_instance)
		queue_free()

