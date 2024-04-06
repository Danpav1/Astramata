extends Area2D

@export var health_component : HealthComponent

func damage(attack_damage : float):
	if health_component:
		health_component.damage(attack_damage)
