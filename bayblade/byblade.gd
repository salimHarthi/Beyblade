extends CharacterBody2D
class_name Byblade

signal on_damage
const max_speed = 300
const accel = 15
const fric = 10
const bounce_factor = 1.3
const dash_speed = 600
const max_helth = 10000
var dash_duration = 0.2
var is_dashing = false
var can_Dash = true
var direction = Vector2.ZERO
var helth = 10000: 
	set(new_value):
		helth=new_value
		emit_signal('on_damage')
	
var super_state = false : 
	set(new_value):
		super_state=new_value
		if new_value:
			$AnimationPlayer.play("super_state")
		else:
			$AnimationPlayer.play("idel")

var PlayersArray = []


func _ready() -> void:
	$AnimationPlayer.play("idel")
	motion_mode=CharacterBody2D.MOTION_MODE_FLOATING
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		$Camera2D.enabled = false
	for i in GameManager.Players:
		if(multiplayer.get_unique_id() !=i):
			PlayersArray.append(str(i))
		if name== str(i):
			$playerName.text = GameManager.Players[i].name
			
	

func _physics_process(delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id(): return
	movment()
	dash(delta)
	collide()
	move_and_slide()
	if Input.is_action_just_pressed('super_state') && !super_state:
		start_super_state()


	
	
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
		if !collision_info.get_collider():
			return
		var collider_name = collision_info.get_collider().name

		if PlayersArray.has(collider_name):
			print('collid: ', collider_name)
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

func start_super_state():
		super_state =true
		$AnimationPlayer.play("super_state")
		print('super_state',super_state,multiplayer.get_unique_id())
		$SuperState.start()
	
func start_dash():
	is_dashing = true
	dash_duration = 0.2
	can_Dash = false
	$DashTimer.start()

func stop_dash():
	is_dashing = false
	dash_duration = 0


func _on_dash_timer_timeout() -> void:
	can_Dash =true
	
@rpc('any_peer','call_local')
func take_damage(damage:float):
	helth -= damage
	print('taking damage: ',name)

	if (helth <= 0):
		queue_free()
	

func _on_super_state_timeout() -> void:
	super_state = false

	$AnimationPlayer.play("idel")
