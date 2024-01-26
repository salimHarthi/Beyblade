extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.name == 'hitBox':
		$CollisionShape2D.disabled = true
		$Timer.start()
		print(area.damage)
	


func _on_timer_timeout() -> void:
	$CollisionShape2D.disabled = false
