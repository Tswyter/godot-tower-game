# This script controls
# - Character movement (speed, direction, input methods)
# - Character attack radius
# - Character projectile firing

extends CharacterBody2D
class_name Player

@onready var projectile_scene = preload("res://scenes/entities/player/projectile.tscn")
@export var joystick: VirtualJoystick
@export var speed = 600

var attack_range_size := PlayerManager.attack_range
var enemy_position: Vector2
var shoot_timer: Timer
var fire_rate: float = 1
var can_shoot := false

var movement_enabled = true

func _ready():
	set_up_shoot_timer()
	global_position = GameManager.viewport_size / 2

func _process(delta):
	if PlayerManager.input_enabled:
		enable_player_movement(delta)
		render_attack_radius()
		EnemyManager.reorder_enemies_by_distance()
		if can_shoot and enemy_position:
			call_deferred("begin_shooting", enemy_position)

#region player movement
func enable_player_movement(delta):
	if joystick and joystick.is_pressed:
		var movement = joystick.output * speed * delta
		var collision = move_and_collide(movement)
		
		if collision:
			var collider = collision.get_collider()
			if collider and collider.is_in_group("enemy"):
				on_enemy_collision(collider)

	global_position.x = clamp(global_position.x, 0, get_viewport().size.x)
	global_position.y = clamp(global_position.y, 0, get_viewport().size.y)
	
func on_enemy_collision(enemy):
	PlayerManager.take_damage(enemy.collision_damage)
	print("ouch! Player hit. Health at: " + str(PlayerManager.health))
	enemy.queue_free()
#endregion

#region player targeting and attack
func set_up_shoot_timer():
	shoot_timer = Timer.new()
	shoot_timer.wait_time = fire_rate
	shoot_timer.one_shot = true
	shoot_timer.connect("timeout", _on_shoot_timer_timeout)
	add_child(shoot_timer)
	
func _on_shoot_timer_timeout():
	can_shoot = true

func render_attack_radius():
	$AttackRadius.scale = Vector2(attack_range_size, attack_range_size)

func _on_attack_radius_body_entered(body):
	if body.is_in_group("enemy"):
		can_shoot = true
		enemy_position = body.global_position

func _on_attack_radius_body_exited(body):
	if is_instance_valid(body) and body.is_in_group("enemy"):
		can_shoot = false
		enemy_position = Vector2.ZERO # (0, 0)
		body.is_targeted = false

func begin_shooting(enemy_position):
	var projectile = projectile_scene.instantiate()
	var projectile_container = get_node("ProjectileContainer")
	projectile_container.add_child(projectile)
	projectile.top_level = true
	projectile.target(enemy_position)
	can_shoot = false
	shoot_timer.start()
#endregion
