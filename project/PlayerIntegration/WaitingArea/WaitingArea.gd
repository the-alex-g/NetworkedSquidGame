extends Control

onready var _start_button := $StartButton

var _error

func _ready():
		modulate = Color(1,1,1,0)
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

func _on_Lobby_color_picked():
	if get_tree().is_network_server():
		_start_button.disabled = false
		_start_button.visible = true
	_error = $Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.0)
	_error = $Tween.start()

puppet func start_game():
	_error = get_tree().change_scene("res://Game/Game.tscn")
