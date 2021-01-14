extends Node2D

var color = null

func _ready():
	$AnimationPlayer.play("Fade")

func _process(_delta):
	if color != null:
		$AnimationPlayer.stop()
		$ColorRect.color = color
