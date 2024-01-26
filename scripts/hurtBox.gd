class_name  HurtBox
extends Area2D

var timer:Timer

func _init() -> void:
	timer =Timer.new()
	add_child(timer)
	timer.one_shot= true
	timer.wait_time = 0.2
	timer.timeout.connect(_on_timer_timeout)

func _ready() -> void:
	connect("area_entered",_on_area_entered)

func _on_area_entered(area: Area2D) -> void:

	if area.name == 'HitBox' && area.owner.name != owner.name:
		if owner.has_method("take_damage"):
			owner.take_damage.rpc(area.damage)
		$CollisionShape2D.disabled = true
		timer.start()

	


func _on_timer_timeout() -> void:
	$CollisionShape2D.disabled = false
