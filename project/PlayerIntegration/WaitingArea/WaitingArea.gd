extends Control

onready var _start_button := $StartButton

var _error

func _ready():
	if get_tree().is_network_server():
		_start_button.disabled = false
		_start_button.visible = true
	else:
		_start_button.disabled = true
		_start_button.visible = false

func _process(_delta):
	var colors := Global.colors
	for color in colors:
		var position = colors.find(color)
		var playerindicator := get_node("PlayerIndicators/PlayerIndicator"+str(position))
		playerindicator.color = color

func _on_StartButton_pressed():
	rpc("start_game")
	start_game()

puppet func start_game():
	_error = get_tree().change_scene("res://Game/Game.tscn")
