class_name KillZone
extends Area2D

func _ready() -> void:
	connect("area_entered",_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	area.owner.queue_free()
