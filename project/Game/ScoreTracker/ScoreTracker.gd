extends Node2D

const progress_bar := preload("res://Game/ScoreTracker/RadialProgressBar.tscn")

var pos := [Vector2(0,0), Vector2(665, 665), Vector2(665,0), Vector2(0,665)]

func _ready():
	var _rotation_increment := 360.0/Global.player_colors.size()
	for player_id in Global.player_colors:
		var bar := progress_bar.instance()
		bar.name = str(player_id)
		bar.color = Global.player_colors[player_id]
		var _position = Global.colors.find(bar.color)
		bar.position = pos[_position]
		add_child(bar)
