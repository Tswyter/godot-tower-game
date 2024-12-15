extends Node

@export var viewport_size: Vector2
var rng = RandomNumberGenerator.new()
enum State {
	PLAY, # 0
	PAUSE, # 1
	UPGRADE, # 2
	GAME_OVER, # 3
}

var current_state = State.PLAY

func _ready():
	viewport_size = get_viewport().size
	start_game()

func start_game():
	PlayerManager.load_player()
	WaveManager.begin_wave()
	# PlayerManager.load_player()
	# add player to main scene
	# begin enemy spawning
	# start wave counter
	# start any timers

func game_over():
	current_state = State.GAME_OVER
	EnemyManager.clear_enemies()
	# stop enemy spawning
	# stop any timers
	# reset wave counter
	# remove any projectiles
	# present player with upgrade UI
	pass
