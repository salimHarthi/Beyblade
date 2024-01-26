class_name HitBox
extends Area2D

var damage = 1
const damage_factor = 0.7
func _physics_process(delta: float) -> void:
	if owner.velocity == Vector2.ZERO && !$CollisionPolygon2D.disabled:
		$CollisionPolygon2D.disabled = true
	elif $CollisionPolygon2D.disabled && owner.velocity != Vector2.ZERO:
		$CollisionPolygon2D.disabled = false
	damage = owner.velocity.length() * damage_factor
	if owner.super_state:
		damage = damage *1.5
	if owner.velocity.length() > 0:
		rotation = lerp_angle(rotation, atan2(owner.velocity.y, owner.velocity.x), 0.1)
