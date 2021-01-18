extends Node2D

const _Player := preload("res://Game/Player/Player.tscn")

onready var _players := $Players
onready var squid := $SquidBody/ColoredSquidParts

var max_score:int

func _ready():
	$AnimationPlayer2.play("Wave_Arms")
	max_score = Global.colors.size()*5
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

func _process(_delta):
	var scores := Global.score
	for score in scores:
		if scores[score] >= max_score:
			_get_winner(score)

func _get_winner(color):
	_players.hide()
	squid.modulate = color
	$AnimationPlayer.play("Winner")
	get_tree().paused = true
