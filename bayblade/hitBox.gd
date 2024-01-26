extends Area2D

var damage = 1
const damage_factor = 0.7
func _physics_process(delta: float) -> void:
	damage = owner.velocity.length() * damage_factor
	if owner.velocity.length() > 0:
		rotation = lerp_angle(rotation, atan2(owner.velocity.y, owner.velocity.x), 0.1)
