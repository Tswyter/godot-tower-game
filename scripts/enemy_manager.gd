extends Node

@onready var enemy_scene = preload("res://scenes/entities/enemies/enemy.tscn")

var enemies := []

func spawn_enemy():
	if GameManager.current_state == GameManager.State.PLAY:
		var enemy = enemy_scene.instantiate()
		enemy.position = Utilities.get_position_outside_viewport(40)
		add_child(enemy)
	else:
		pass

func erase_enemy_from_array(enemy):
	enemies.erase(enemy)
	enemy.queue_free()
	
func add_enemy_to_array(enemy):
	enemies.append(enemy)
	
func reorder_enemies_by_distance():
	if enemies.size() > 0 and is_instance_valid(enemies[0]):
		enemies.sort_custom(func (a, b):
			return a.global_position.distance_to(PlayerManager.player.global_position) < b.global_position.distance_to(PlayerManager.player.global_position)
		)

func clear_enemies():
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
