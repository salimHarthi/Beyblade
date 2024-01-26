extends Sprite2D

func _physics_process(delta: float) -> void:
	rotation_degrees += 720 * delta
	if rotation_degrees >=360:
		rotation_degrees = 0 
