extends Node2D

var id := 0
var _value := 0
var _max_value := 0
var color:Color

func _ready():
	id = get_tree().get_network_unique_id()
	$RadialProgressBar.tint_progress = color
	_max_value = Global.score.size()*5
	$RadialProgressBar.max_value = _max_value

func _process(_delta):
	$RadialProgressBar.value = Global.score[color] if Global.score.has(color) else 0
