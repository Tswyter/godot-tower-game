extends Node2D

@onready var play_scene_path: String = "res://scenes/game_state/play_scene.tscn"
@onready var game_over_scene_path: String = "res://scenes/game_state/game_over.tscn"

var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	load_scene(play_scene_path)

func load_scene(scene_path: String):
	if current_scene:
		print(current_scene.name)
		current_scene.queue_free()
		
	var new_scene = load(scene_path).instantiate()
	print(new_scene.name)
	add_child(new_scene)
	current_scene = new_scene
	
func go_to_play_scene():
	load_scene(play_scene_path)
	
func go_to_game_over_scene():
	load_scene(game_over_scene_path)
	
func go_to_upgrade_scene():
	pass
	
func reload_current_scene():
	if current_scene:
		load_scene(current_scene.filename)
