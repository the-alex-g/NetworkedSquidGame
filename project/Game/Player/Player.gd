class_name Player
extends Node2D

const _Bullet := preload("res://Game/Bullets/Bullet.tscn")

onready var _bullet_spawn_point := $BulletSpawnPoint

var color:Color
var id:int

func _process(_delta):
	if is_network_master():
		var direction := 0.0
		if Input.is_action_pressed("counterclockwise"):
			direction -= 1.0
		if Input.is_action_pressed("clockwise"):
			direction += 1.0
		if Input.is_action_just_pressed("shoot"):
			rpc("spawn_bullet")
			spawn_bullet()
		rotation_degrees += direction
		rpc_unreliable("update_position", rotation_degrees)

remote func update_position(new_rotation):
	rotation_degrees = new_rotation

remote func spawn_bullet():
	var bullet := _Bullet.instance()
	bullet.rotation_degrees = rotation_degrees
	bullet.position = _bullet_spawn_point.get_global_transform().origin
	bullet.player_who_shot = id
	bullet.color = color
	get_tree().get_root().add_child(bullet)

func _draw():
	draw_circle(Vector2(0,-250), 10.0, color)
