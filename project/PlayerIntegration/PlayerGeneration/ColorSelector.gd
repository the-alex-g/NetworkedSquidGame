extends Control


onready var _red_slider := $VBoxContainer/R
onready var _blue_slider := $VBoxContainer/B
onready var _green_slider := $VBoxContainer/G
onready var _rvalue := $VBoxContainer2/RLabel
onready var _bvalue := $VBoxContainer2/BLabel
onready var _gvalue := $VBoxContainer2/GLabel

var _r := 1.0
var _b := 1.0
var _g := 1.0
var color := Color(0,0,0,1)
var _error

signal done

func _ready():
	$AnimationPlayer.play("Wave_Arms")

func _process(_delta):
	_rvalue.text = str(_red_slider.value)
	_bvalue.text = str(_blue_slider.value)
	_gvalue.text = str(_green_slider.value)
	_r = _red_slider.value/255.0
	_b = _blue_slider.value/255.0
	_g = _green_slider.value/255.0
	color = Color(_r, _g, _b, 1.0)
	$SquidBody/ColoredSquidParts.modulate = color

func _on_ConfirmButton_pressed():
	Global.rpc("set_player_color", get_tree().get_network_unique_id(), color)
	emit_signal("done")
