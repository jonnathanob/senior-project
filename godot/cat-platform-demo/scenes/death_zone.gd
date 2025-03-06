extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if area is HitboxComponent:
		area.damage(area.health_component.health)
