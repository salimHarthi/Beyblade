extends CharacterBody2D

var collision_info: KinematicCollision2D

func _physics_process(delta: float) -> void:
	
	for i in get_slide_collision_count():
		collision_info = get_slide_collision(i)
		print(collision_info)
		if collision_info.get_collider().name == "Byblade":
			if velocity == Vector2.ZERO:
				velocity = collision_info.get_collider_velocity()
			else:
				velocity = collision_info.get_collider_velocity() + velocity.reflect(collision_info.get_normal())
			print(collision_info.get_collider().name,velocity )


	#velocity=Vector2(1,0)
		
	move_and_slide()
	

