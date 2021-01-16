extends Node

var _error
var player_ids := []
var player_colors := {}
var colors := []
var score := {}
var id:int

sync func set_player_color(player_id:int, color:Color):
	player_colors[player_id] = color
	colors.append(color)

sync func add_player(player_id:int):
	player_ids.append(player_id)

sync func remove_player(player_id:int):
	player_ids.erase(player_id)
	_error = player_colors.erase(player_id)

func update_score(color):
	print(str(color))
	if score.has(color):
		score[color] += 1
	else:
		score[color] = 1
	print(str(score))
