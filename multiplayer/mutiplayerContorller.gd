extends Control

var address = "127.0.0.1"
var port = 8910
var peer:ENetMultiplayerPeer
func _ready() -> void:
	multiplayer.peer_connected.connect(playerConnected)
	multiplayer.peer_disconnected.connect(playerdisconnected)
	multiplayer.connected_to_server.connect(playerToserver)
	multiplayer.connection_failed.connect(connectionFaild)
	
@rpc("any_peer")
func sendPlayerInfo(name,id):
	if !GameManager.Players.has(id):
		GameManager.Players[id]={
			"name":name,"id":id
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			sendPlayerInfo.rpc(GameManager.Players[i].name,i)
			
@rpc("any_peer","call_local")
func startGame():
	var scene = load("res://levels/battle_level.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error =peer.create_server(port,2)
	if error != OK:
		print("error ",error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")
	sendPlayerInfo($LineEdit.text,multiplayer.get_unique_id())

func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)



func _on_start_button_down() -> void:
	startGame.rpc()
	pass # Replace with function body.

func playerConnected(id):
	print("playerConnected ",id)
	
func playerdisconnected(id):
	print("player disconnected ",id)
	
func playerToserver():
	print("connected to server")
	sendPlayerInfo.rpc_id(1,$LineEdit.text,multiplayer.get_unique_id())
	
func connectionFaild():
	print("connection faild ")
