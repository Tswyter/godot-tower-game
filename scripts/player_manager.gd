extends Node

@onready var player_scene = load('res://scenes/entities/player/player.tscn')

var player: Node2D
var attack_range := 1.0
var health := 100.0
var resources = 0.0

func _ready():
	player = player_scene.instantiate()

func load_player():
	if player:
		add_child(player)

func add_resource(value: float):
	resources += value

func take_damage(damage: float):
	health -= damage
	if health <= 0:
		die()
		
func die():
	print("player has died with " + str(resources) + " resources")
	GameManager.game_over()
