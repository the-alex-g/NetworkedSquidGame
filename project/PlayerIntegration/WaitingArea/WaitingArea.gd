extends Control

onready var _start_button := $StartButton

func _ready():
	if get_tree().is_network_server():
		_start_button.disabled = false
		_start_button.visible = true
	else:
		_start_button.disabled = true
		_start_button.visible = false

func _on_StartButton_pressed():
	pass # Go play game
