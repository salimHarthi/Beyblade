extends CharacterBody2D
class_name Byblade

const max_speed = 200
const accel = 10
const fric = 10
const bounce_factor = 0.5
const dash_speed = 500
var dash_duration = 0.2
var is_dashing = false
var can_Dash = true
var direction = Vector2.ZERO

func _ready() -> void:
	motion_mode=CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	movment()
	dash(delta)
	collide()
	move_and_slide()
	
	
func movment()->void:
	direction = Input.get_vector('move_left',"move_right",'move_up','move_down')
		
	if direction == Vector2.ZERO:
		if velocity.length()> fric:
			velocity-= velocity.normalized() * fric
		else:
			velocity = Vector2.ZERO
	else:
		velocity += direction * accel
		velocity = velocity.limit_length(max_speed)
		
		

func collide( )-> void:
	for i in get_slide_collision_count():
		var collision_info = get_slide_collision(i)
		var collider_name = collision_info.get_collider().name
		
		if collider_name == "Enemy":
			var collider_velocity = collision_info.get_collider_velocity()
			var normal = collision_info.get_normal()
			# Calculate the new velocity based on the collider's velocity and the collision normal
			velocity = collider_velocity.project(normal).normalized() * collider_velocity.length() * bounce_factor
		elif collider_name == "TileMap":
			velocity=velocity.bounce(collision_info.get_normal())

func dash(delta:float)-> void:
	if Input.is_action_just_pressed("dash") && can_Dash:
		start_dash()
	if Input.is_action_just_released("dash"):
		stop_dash()
	if(is_dashing):
		velocity = direction * dash_speed
		dash_duration -= delta
		if dash_duration <= 0:
			stop_dash()
		

func start_dash():
	is_dashing = true
	dash_duration = 0.2
	can_Dash = false
	$DashTimer.start()

func stop_dash():
	is_dashing = false
	dash_duration = 0
#func bounce_power_calc()->float:
	#var bounce_power = collision_info.get_collider_velocity().length() - velocity.length()
	#return 0
	#if(bounce_power<0):
		#print("bounce_power win",bounce_power)
		#return bounce_power * bounce_factor
	#elif(bounce_power==0):
		#print("bounce_power idel",bounce_power)
		#return bounce_power * bounce_factor
	#else:
		#print("bounce_power loos",bounce_power)	
		#return bounce_power * bounce_factor

	
	


func _on_dash_timer_timeout() -> void:
	can_Dash =true
	
