extends Node2D

const _Player := preload("res://Game/Player/Player.tscn")

onready var _players := $Players

func _ready():
	var _rotation := 0.0
	var _rotation_increment := 360.0/Global.player_colors.size()
	for player_id in Global.player_colors:
		var player := _Player.instance()
		player.name = str(player_id)
		player.set_network_master(player_id)
		player.color = Global.player_colors[player_id]
		player.rotation_degrees = _rotation
		player.position = Vector2(350,350)
		_rotation += _rotation_increment
		_players.add_child(player)
