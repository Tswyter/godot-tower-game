# This script controls
# - Character movement (speed, direction, input methods)
# - Character attack radius
# - Character projectile firing

extends CharacterBody2D

@onready var projectile_scene = load("res://scenes/entities/player/projectile.tscn")

var attack_range_size := PlayerManager.attack_range
@export var speed = 400
@export var joystick: VirtualJoystick

var movement_enabled = true

func _ready():
	global_position = GameManager.viewport_size / 2

func _process(delta):
	enable_player_movement(delta)
	render_attack_radius()
	EnemyManager.reorder_enemies_by_distance()

#region player movement
func enable_player_movement(delta):
	if joystick and joystick.is_pressed:
		var movement = joystick.output * speed * delta
		var collision = move_and_collide(movement)
		
		if collision:
			var collider = collision.get_collider()
			if collider and collider.is_in_group("enemy"):
				print('collided with enemy')
				on_enemy_collision(collider)

	global_position.x = clamp(global_position.x, 0, get_viewport().size.x)
	global_position.y = clamp(global_position.y, 0, get_viewport().size.y)

func disable_player_movement():
	movement_enabled = false
#endregion

#region player targeting and attack
func render_attack_radius():
	$AttackRadius.scale = Vector2(attack_range_size, attack_range_size)

func _on_attack_radius_body_entered(body):
	if body.is_in_group("enemy"):
		call_deferred("begin_shooting", body.global_position)

func _on_attack_radius_body_exited(body):
	if is_instance_valid(body) and body.is_in_group("enemy"):
		# stop shooting projectiles
		body.is_targeted = false

func begin_shooting(enemy_position):
	var projectile = projectile_scene.instantiate()
	projectile.top_level = true
	add_child(projectile)
	projectile.target(enemy_position)
#endregion

func on_enemy_collision(enemy):
	PlayerManager.health -= enemy.collision_damage
	print("ouch! Player hit. Health at: " + str(PlayerManager.health))
	enemy.queue_free()
