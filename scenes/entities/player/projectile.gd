extends Area2D
class_name Projectile

var velocity: Vector2
var target_position: Vector2
var speed := 200
var damage := 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = PlayerManager.player.global_position
	PlayerManager.projectiles_fired.append(self)

func _process(delta):
	global_position += target_position * speed * delta
	if Utilities.detect_position_outside_viewport(global_position):
		clear_projectile()

func target(enemy_position: Vector2):
	target_position = (enemy_position - global_position).normalized()
	look_at(enemy_position)

func clear_projectile():
	PlayerManager.projectiles_fired.erase(self)
	queue_free()

func hit(enemy):
	enemy.take_damage(damage)
	clear_projectile()

func _on_body_entered(area):
	if area.is_in_group("enemy"):
		hit(area)
