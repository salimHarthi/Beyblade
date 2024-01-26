extends Node2D

@export var PlayerScene: PackedScene 

func _ready() -> void:
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)

		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("playerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index+=1
