extends Control


func _ready() -> void:
	GameManager.on_start_the_Game.connect(_on_start_button_down)
	multiplayer.peer_connected.connect(playerConnected)
	multiplayer.peer_disconnected.connect(playerdisconnected)
	$ItemList.add_item(str(multiplayer.get_unique_id()))
	

func playerConnected(id):
	$ItemList.add_item(str(id))
	print("playerConnected ",id)
	
func playerdisconnected(id):
	for i in $ItemList.get_item_count():
		if $ItemList.get_item_text(i) == str(id):
			$ItemList.remove_item(i)
	print("player disconnected lobby ",id)


func _on_start_button_down() -> void:
	startGame.rpc()
	queue_free()
	pass # Replace with function body.

@rpc("any_peer","call_local")
func startGame():
	var scene = load("res://levels/battle_level.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()


func _on_leave_button_down() -> void:
	var node = get_tree().root.get_children()
	for i in node:
		if i.name =='Control':
			i.peer.close()
			GameManager.Players = {}
			i.show()
			queue_free()
	
