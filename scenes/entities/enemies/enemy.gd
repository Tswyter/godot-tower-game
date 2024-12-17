extends CharacterBody2D
class_name Enemy

var speed := 300.0
var health := 10.0
var collision_damage := 100.0
var target_position: Vector2
var resource_value := 1.0
var is_targeted := false

func _ready():
	EnemyManager.add_enemy_to_array(self)
	health *= float(WaveManager.current_wave) / 2

func _process(delta):
	if is_instance_valid(PlayerManager.player):
		move_to_player(delta)

func move_to_player(delta):
	target_position = PlayerManager.player.global_position
	look_at(target_position)
	global_position = global_position.move_toward(target_position, speed * delta)
	
func take_damage(damage: float):
	health -= damage
	if health <= 0.0:
		die()
		
func damage_player(damage: float):
	PlayerManager.take_damage(damage)
		
func die():
	PlayerManager.add_resource(resource_value)
	EnemyManager.erase_enemy_from_array(self)
		
