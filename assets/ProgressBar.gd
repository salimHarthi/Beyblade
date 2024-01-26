extends ProgressBar

func _ready() -> void:
	max_value = owner.owner.max_helth
	value= owner.owner.helth
	owner.owner.connect('on_damage',_on_damage_taken)
	
func _on_damage_taken():
	value= owner.owner.helth
