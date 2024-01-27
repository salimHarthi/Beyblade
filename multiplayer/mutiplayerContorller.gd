class_name MainPage
extends Control

var address = "0.0.0.0"
var port = 8910
var peer:ENetMultiplayerPeer
func _ready() -> void:

	multiplayer.peer_connected.connect(playerConnected)
	multiplayer.peer_disconnected.connect(playerdisconnected)
	multiplayer.connected_to_server.connect(playerToserver)
	multiplayer.connection_failed.connect(connectionFaild)
	if "--server" in OS.get_cmdline_args():
		hostGame()
		

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


func hostGame():
	peer = ENetMultiplayerPeer.new()
	port = int($port.text)
	var error =peer.create_server(port,2)
	if error != OK:
		print("error ",error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")
	
func _on_host_button_down() -> void:
	hostGame()
	var scene = load("res://multiplayer/lobby.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	sendPlayerInfo($LineEdit.text,multiplayer.get_unique_id())

func _on_join_button_down() -> void:
	address = $serverIp.text
	port = int($port.text)
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)

	multiplayer.set_multiplayer_peer(peer)
	var scene = load("res://multiplayer/lobby.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	



func _on_start_button_down() -> void:
	#startGame.rpc()
	pass # Replace with function body.

func playerConnected(id):
	print("playerConnected ",id)
	
func playerdisconnected(id):
	print("player disconnected contorl",id)
	print(GameManager.Players)
	GameManager.Players.erase(id)
	print(GameManager.Players)
	var players = get_tree().get_nodes_in_group('player')
	for i in players:
		if i.name == str(id):
			i.queue_free()
			
func playerToserver():
	print("connected to server")
	sendPlayerInfo.rpc_id(1,$LineEdit.text,multiplayer.get_unique_id())
	
func connectionFaild():
	print("connection faild ")


