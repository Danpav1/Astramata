extends RigidBody2D

var explosion = preload("res://Scenes/Gameplay/Entities/Projectiles/BlueLaserImpact.tscn")
var damage = 10.0
var speed = 1500.0
var fire_rate = 0.1

func _on_body_entered(body):
	var health_node = body.get_node_or_null("HealthComponent")
	if !body.is_in_group("player"):
		if health_node and health_node.has_method("damage"):
			health_node.damage(damage)
			var explosion_instance = explosion.instantiate()
			explosion_instance.position = get_global_position()
			get_parent().add_child(explosion_instance)
			queue_free()
