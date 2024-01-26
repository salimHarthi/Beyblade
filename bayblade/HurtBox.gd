extends Area2D



func _on_area_entered(area: Area2D) -> void:
	if area.name == 'hitBox' && area.owner.name != owner.name:
		print("player",area.damage)
