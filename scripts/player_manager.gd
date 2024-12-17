extends Node

@onready var player_scene = load('res://scenes/entities/player/player.tscn')

var player: Node2D
var attack_range := 1.0
var health := 100.0
var resources = 0.0
var input_enabled := false
var projectiles_fired = []

func _ready():
	player = player_scene.instantiate()
	health = 100.0

func load_player():
	if is_instance_valid(player):
		add_child(player)
		input_enabled = true

func add_resource(value: float):
	resources += value

func take_damage(damage: float):
	health -= damage
	check_health_status()
		
func check_health_status():
	if health <= 0:
		die()

func deactivate_player():
	input_enabled = false
	player.hide()

func destroy_projectiles():
	for projectile in projectiles_fired:
		projectile.queue_free()

func die():
	deactivate_player()
	destroy_projectiles()
	print("player has died with " + str(resources) + " resources")
	GameManager.game_over()
