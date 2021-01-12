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
		print("server creation failed: "+_error)
	else:
		print("server created")
	get_tree().network_peer = network

func _on_Join_pressed():
	var network := NetworkedMultiplayerENet.new()
	_error = network.create_client("127.0.0.1", 4242)
	if _error != OK:
		print("client creation failed: "+_error)
	else:
		print("client created")
	get_tree().network_peer = network

func _connected_to_server():
	print("Connected OK")

func _connection_failed():
	print("Connection failed")

func _player_connected(id:int):
	print("player connected")
	Global.players[id] = Color(0,0,0,255)

func _player_disconnected(id):
	_error = Global.players.erase(id)

func _server_connection_lost():
	print("server connection lost")
