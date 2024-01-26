extends CharacterBody2D
class_name Enemy

const max_speed = 200
const accel = 10
const fric = 10
const bounce_factor = 0.5



func _ready() -> void:
	motion_mode=CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	collide()
	move_and_slide()

func collide() -> void:
	for i in get_slide_collision_count():
		var collision_info = get_slide_collision(i)
		var collider_name = collision_info.get_collider().name

		if collider_name == "Byblade":
			var collider_velocity = collision_info.get_collider_velocity()
			var normal = collision_info.get_normal()

			# Calculate the new velocity based on the collider's velocity and the collision normal
			velocity = collider_velocity.project(normal).normalized() * collider_velocity.length() * bounce_factor

