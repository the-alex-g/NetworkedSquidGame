extends Control

enum Inputchange {COUNTER, CLOCK, SHOOT, NONE}

var _error
var _input_change = Inputchange.NONE

func _ready():
	$Camera2D.position = Vector2.ZERO
	_error = get_tree().connect("connected_to_server", self, "_connected_to_server")
	_error = get_tree().connect("connection_failed", self, "_connection_failed")
	_error = get_tree().connect("network_peer_connected", self, "_player_connected")
	_error = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	_error = get_tree().connect("server_disconnected", self, "_server_connection_lost")

func _input(event:InputEvent):
	if event is InputEventKey:
		match _input_change:
			Inputchange.COUNTER:
				InputMap.action_add_event("counterclockwise", event)
				_input_change = Inputchange.NONE
			Inputchange.CLOCK:
				InputMap.action_add_event("clockwise", event)
				_input_change = Inputchange.NONE
			Inputchange.SHOOT:
				InputMap.action_add_event("shoot", event)
				_input_change = Inputchange.NONE

func _process(_delta):
	$HBoxContainer/VBoxContainer2/Counterclockwise.text = "Counterclockwise: "+get_key(InputMap.get_action_list("counterclockwise"))
	$HBoxContainer/VBoxContainer2/Clockwise.text = "Clockwise: "+get_key(InputMap.get_action_list("clockwise"))
	$HBoxContainer/VBoxContainer2/Shoot.text = "Shoot: "+get_key(InputMap.get_action_list("shoot"))

func get_key(events:Array)->String:
	var string := ""
	for event in events:
		var code:int = event.scancode
		string = OS.get_scancode_string(code)
	return string

func _on_Host_pressed():
	var network := NetworkedMultiplayerENet.new()
	_error = network.create_server(4242, 4)
	if _error != OK:
		print("server creation failed: "+str(_error))
	else:
		print("server created")
	get_tree().network_peer = network
	Global.add_player(1)
	next()

func _on_Join_pressed():
	var network := NetworkedMultiplayerENet.new()
	_error = network.create_client("127.0.0.1", 4242)
	if _error != OK:
		print("client creation failed: "+_error)
	else:
		print("client created")
	get_tree().network_peer = network
	yield(get_tree().create_timer(0.1), "timeout")
	next()

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

func next():
	$VBoxContainer.hide()
	$VBoxContainer/Host.disabled = true
	$VBoxContainer/Join.disabled = true
	$VBoxContainer/Settings.disabled = true
	$AnimationPlayer.play("CameraSlide")

func _on_Settings_pressed():
	$AnimationPlayer.play("Settings")
	$VBoxContainer.hide()

func _on_Back_pressed():
	$AnimationPlayer.play("Return")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Return":
		$VBoxContainer.show()

func _on_Counterclockwise_pressed():
	InputMap.action_erase_events("counterclockwise")
	_input_change = Inputchange.COUNTER 

func _on_Clockwise_pressed():
	InputMap.action_erase_events("clockwise")
	_input_change = Inputchange.CLOCK

func _on_Shoot_pressed():
	InputMap.action_erase_events("shoot")
	_input_change = Inputchange.SHOOT

func _on_Fullscreen_toggled(button_pressed:bool):
	OS.window_fullscreen = button_pressed
