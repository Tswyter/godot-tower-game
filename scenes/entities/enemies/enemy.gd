extends CharacterBody2D

var speed := 100.0
var health := 10.0
var collision_damage := 10.0
var target_position: Vector2
var resource_value := 1.0
var is_targeted := false

func _ready():
	EnemyManager.add_enemy_to_array(self)
	health *= float(WaveManager.current_wave / 2)

func _process(delta):
	move_to_player(delta)
	if is_targeted:
		rotate(45.0)

func move_to_player(delta):
	target_position = PlayerManager.player.global_position
	look_at(target_position)
	global_position = global_position.move_toward(target_position, speed * delta)
	# if global_position == target_position:
	#	damage_player(collision_damage)
	
func take_damage(damage: float):
	health -= damage
	if health <= 0.0:
		die()
		
func damage_player(damage: float):
	PlayerManager.take_damage(damage)
		
func die():
	PlayerManager.add_resource(resource_value)
	EnemyManager.erase_enemy_from_array(self)
		
