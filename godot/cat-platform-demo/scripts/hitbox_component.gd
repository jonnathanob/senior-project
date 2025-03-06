extends Area3D

class_name HitboxComponent

@export var health_component: HealthComponent
@export var disabled: bool

func damage(dmg: int):
	if health_component and not disabled:
		health_component.damage(dmg)
