class_name Player
extends Node2D

var color:Color

func _process(_delta):
	if is_network_master():
		var direction := 0.0
		if Input.is_action_pressed("counterclockwise"):
			direction -= 1.0
		if Input.is_action_pressed("clockwise"):
			direction += 1.0
		rotation_degrees += direction
		rpc_unreliable("update_position", rotation_degrees)

remote func update_position(new_rotation):
	rotation_degrees = new_rotation

func _draw():
	draw_circle(Vector2(0,-200), 10.0, color)
