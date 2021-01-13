extends Node

var players := {}
var id:int

sync func set_player_color(player_id:int, color:Color):
	players[player_id] = color
	print("Color Set")

sync func add_player(player_id:int):
	players[player_id] = Color(0,0,0,1)
	print("new player added")
