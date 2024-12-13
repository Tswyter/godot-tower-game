extends Node

@onready var player_scene = load('res://scenes/entities/player/player.tscn')

var player: Node2D
var attack_range := 0.0
var health := 100.0
var resources = {
	'upgrades': 0.0
}

func _ready():
	player = player_scene.instantiate()

func load_player():
	if player:
		add_child(player)

func add_resource(type: String, value: float):
	resources[type] += value
