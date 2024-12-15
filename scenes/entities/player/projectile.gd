extends Area2D

var velocity: Vector2
var target_position: Vector2
var speed := 500.0
var steer_force: float = 50.0
var damage := 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = PlayerManager.player.global_position

func _process(delta):
	global_position += target_position * speed * delta

func target(enemy_position: Vector2):
	target_position = (enemy_position - global_position).normalized()

func hit(enemy):
	enemy.take_damage(damage)
	queue_free()

func _on_body_entered(area):
	if area.is_in_group("enemy"):
		hit(area)
