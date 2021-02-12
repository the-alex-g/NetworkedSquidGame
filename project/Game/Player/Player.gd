class_name Player
extends Node2D

const _Bullet := preload("res://Game/Bullets/Bullet.tscn")

onready var _bullet_spawn_point := $BulletSpawnPoint
onready var _animation_player := $AnimationTree
onready var _squid := $SquidBody/ColoredSquidParts
onready var _anim_change_timer := $Timer
onready var scorebar := $RadialProgressBar/RadialProgressBar

export var blend_amount := 4

var color:Color
var id:int
var shooting := false
var cooling_down := false
var alpha_value := 1.0
var invincible := false

func _ready():
	id = get_tree().get_network_unique_id()
	var shoot_anim_length = $AnimationPlayer.get_animation("Shoot").length
	scorebar.tint_progress = color
	scorebar.max_value = Global.colors.size()*5
	scorebar.value = 0
	_anim_change_timer.wait_time = shoot_anim_length

func _process(delta):
	scorebar.value = Global.score[color] if Global.score.has(color) else 0
	_squid.modulate = Color(color.r, color.g, color.b, alpha_value)
	if not shooting and not cooling_down:
		_animation_player.set("parameters/Blend2/blend_amount", 0)
	elif not shooting and cooling_down:
		if _animation_player.get("parameters/Blend2/blend_amount") > 0:
			var current_blend = _animation_player.get("parameters/Blend2/blend_amount")
			var new_blend = current_blend - delta*blend_amount
			_animation_player.set("parameters/Blend2/blend_amount", new_blend)
		else:
			cooling_down = false
	elif shooting:
		invincible = false
		$Tween.stop_all()
		$Tween.interpolate_property(self, "alpha_value", null, 1.0, 0.5)
		$Tween.start()
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
		rotation_degrees += direction
		if direction != 0.0:
			rpc_unreliable("update_position", rotation_degrees)

remote func update_position(new_rotation):
	rotation_degrees = new_rotation

remote func spawn_bullet():
	$ShootSound.play()
	var bullet := _Bullet.instance()
	bullet.rotation_degrees = rotation_degrees
	bullet.position = _bullet_spawn_point.get_global_transform().origin
	bullet.player_who_shot = get_tree().get_network_unique_id()
	bullet.color = color
	shooting = true
	_anim_change_timer.start()
	$InvincibilityTimer.start(2.5)
	get_tree().get_root().add_child(bullet)

func _on_Timer_timeout():
	shooting = false
	cooling_down = true

func _on_InvincibilityTimer_timeout():
	invincible = true
	$Tween.interpolate_property(self, "alpha_value", null, 0.5, 0.5)
	$Tween.start()

func _on_Player_area_entered(area):
	if area is Bullet and not invincible:
		if area.color != color:
			$HitSound.play()
			Global.update_score(area.color)

func is_player():
	pass
