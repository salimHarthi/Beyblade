extends CharacterBody2D
class_name Enemy

const max_speed = 200
const accel = 10
const fric = 10
const bounce_factor = 0.5
var image:Sprite2D
var helth = 1000

func _ready() -> void:
	image = $Sprite2D
	motion_mode=CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	byblade_rotate(delta)
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
		elif collider_name == "TileMap":
			velocity=velocity.bounce(collision_info.get_normal())
			
func byblade_rotate(delta:float)->void:
	$Sprite2D.rotation_degrees += 720 * delta
	if rotation_degrees >=360:
		rotation_degrees = 0 

func take_damage(damage:float):
	helth -= damage
	print("helth",helth)
	if (helth <= 0):
		queue_free()
