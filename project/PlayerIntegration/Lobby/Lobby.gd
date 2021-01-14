extends Control

var _error

func _ready():
	_error = get_tree().connect("connected_to_server", self, "_connected_to_server")
	_error = get_tree().connect("connection_failed", self, "_connection_failed")
	_error = get_tree().connect("network_peer_connected", self, "_player_connected")
	_error = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	_error = get_tree().connect("server_disconnected", self, "_server_connection_lost")

func _on_Host_pressed():
	var network := NetworkedMultiplayerENet.new()
	_error = network.create_server(4242, 4)
	if _error != OK:
		print("server creation failed: "+str(_error))
	else:
		print("server created")
	get_tree().network_peer = network
	Global.add_player(1)
	_error = get_tree().change_scene("res://PlayerIntegration/PlayerGeneration/ColorSelector.tscn")

func _on_Join_pressed():
	var network := NetworkedMultiplayerENet.new()
	_error = network.create_client("127.0.0.1", 4242)
	if _error != OK:
		print("client creation failed: "+_error)
	else:
		print("client created")
	get_tree().network_peer = network
	yield(get_tree().create_timer(0.1), "timeout")
	_error = get_tree().change_scene("res://PlayerIntegration/PlayerGeneration/ColorSelector.tscn")

func _connected_to_server():
	print("Connected OK")

func _connection_failed():
	print("Connection failed")

func _player_connected(id:int):
	print("player connected")
	Global.rpc("add_player", id)
	Global.id = id

func _player_disconnected(id:int):
	_error = Global.rpc("remove_player", id)

func _server_connection_lost():
	print("server connection lost")
