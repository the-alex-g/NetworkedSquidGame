extends Node2D

var color = null

func _ready():
	var secs = rand_range(0,6)
	$AnimationPlayer.play("Fade")
	$AnimationPlayer.seek(secs, true)

func _process(_delta):
	if color != null:
		$AnimationPlayer.stop()
		$SquidBody/ColoredSquidParts.modulate = color
		$SquidBody/Sprite.hide()
