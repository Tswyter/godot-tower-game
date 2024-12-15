extends Node

@export var wave_duration: float = 10.0
@export var wave_rest_duration: float = 5.0
@export var initial_spawn_interval: float = 2.0
@export var spawn_interval_decrease: float = 1.0

var current_wave: int = 0
var spawn_timer: float = 0.0
var wave_timer: float = 0.0
var is_wave_active: bool = false

func begin_wave(wave_number: int = 0):
	current_wave = wave_number
	start_next_wave()
	
func _process(delta):
	if GameManager.current_state == GameManager.State.PLAY:
		if is_wave_active:
			wave_timer += delta
			spawn_timer += delta
			if spawn_timer >= get_spawn_interval():
				spawn_timer = 0
				EnemyManager.spawn_enemy()
			
			if wave_timer >= wave_duration:
				is_wave_active = false
				call_deferred("start_wave_rest_period")
		else:
			pass
	else:
		pass
		
func start_next_wave():
	current_wave += 1
	wave_timer = 0.0
	spawn_timer = 0.0
	is_wave_active = true
	
func start_wave_rest_period():
	await get_tree().create_timer(wave_rest_duration).timeout
	start_next_wave()

func get_spawn_interval() -> float:
	return max(0.5, initial_spawn_interval - (current_wave - 1) * spawn_interval_decrease)
