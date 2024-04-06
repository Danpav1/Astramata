extends Node2D

@export var MAX_HEALTH := 1000.0
var health : float

func _ready():
	health = MAX_HEALTH
	
func damage(attack_damage: float):
	health -= attack_damage

	if health <= 0:
		print(health)
		get_parent().queue_free()
