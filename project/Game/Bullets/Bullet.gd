class_name Bullet
extends Area2D

export var speed := 500

var player_who_shot:int
var color:Color

func _ready():
	modulate = color

func _process(delta):
	position += Vector2(0,speed*delta).rotated(rotation)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_area_entered(area):
	if area.has_method("is_player"):
		if area.color != color and not area.invincible:
			Global.update_score(color)
