class_name Bullet
extends Area2D

export var speed := 500

var player_who_shot:int
var color:Color

func _process(delta):
	position += Vector2(0,speed*delta).rotated(rotation)

func _draw():
	draw_circle(Vector2.ZERO, 5, color)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
