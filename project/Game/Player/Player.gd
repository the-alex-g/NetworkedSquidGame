class_name Player
extends Node2D

const _Bullet := preload("res://Game/Bullets/Bullet.tscn")

onready var _bullet_spawn_point := $BulletSpawnPoint
onready var _animation_player := $AnimationTree
onready var _squid := $SquidBody/ColoredSquidParts
onready var _anim_change_timer := $Timer

export var blend_amount := 4

var color:Color
var id:int
var shooting := false
var time_elapsed

func _ready():
	var shoot_anim_length = $AnimationPlayer.get_animation("Shoot").length
	_anim_change_timer.wait_time = shoot_anim_length
	_squid.modulate = color

func _process(delta):
	if not shooting:
		time_elapsed = 0
		_animation_player.set("parameters/Blend2/blend_amount", 0)
	elif shooting:
		if _animation_player.get("parameters/Blend2/blend_amount") < 1:
			var current_blend = _animation_player.get("parameters/Blend2/blend_amount")
			var new_blend = current_blend + delta*blend_amount
			_animation_player.set("parameters/Blend2/blend_amount", new_blend)
	if is_network_master():
		var direction := 0.0
		if Input.is_action_pressed("counterclockwise"):
			direction -= 1.0
		if Input.is_action_pressed("clockwise"):
			direction += 1.0
		if Input.is_action_just_pressed("shoot"):
			rpc("spawn_bullet")
			spawn_bullet()
			shooting = true
			rset("shooting", true)
			_anim_change_timer.start()
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

func _on_Timer_timeout():
	shooting = false
	rset("shooting", false)
