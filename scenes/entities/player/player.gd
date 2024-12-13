# This script controls
# - Character movement (speed, direction, input methods)
# - Character attack radius
# - Character projectile firing

extends CharacterBody2D

@export var touch_indicator_scene: PackedScene = preload("res://scenes/entities/utilities/touch_indicator.tscn")
@export var attack_range_size := 4.0
@export var speed = 200.0
@export var joystick: VirtualJoystick
var move_vector := Vector2.ZERO

var movement_enabled = true

func _process(delta):
	enable_player_movement(delta)
	render_attack_radius()
	
func render_attack_radius():
	$AttackRadius.scale = Vector2(attack_range_size, attack_range_size)

func enable_player_movement(delta):
	global_position.x = clamp(global_position.x, 0, get_viewport().size.x)
	global_position.y = clamp(global_position.y, 0, get_viewport().size.y)
	
	if joystick and joystick.is_pressed:
		position += joystick.output * speed * delta

func disable_player_movement():
	movement_enabled = false

func _on_attack_radius_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.is_in_group("enemy"):
		EnemyManager.reorder_enemies_by_distance()
		if EnemyManager.enemies.size() > 0:
			# begin shooting projectile
			EnemyManager.enemies[0].is_targeted = true

func _on_attack_radius_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if is_instance_valid(body) and body.is_in_group("enemy"):
		EnemyManager.reorder_enemies_by_distance()
		# stop shooting projectiles
		body.is_targeted = false
