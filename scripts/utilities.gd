extends Node

@onready var viewport_size = GameManager.viewport_size
@onready var rng = GameManager.rng

func get_position_outside_viewport(margin: float = 50) -> Vector2:
	var min_x = -margin
	var max_x = viewport_size.x + margin
	var min_y = -margin
	var max_y = viewport_size.y + margin
	# Randomly choose one of the four outside regions
	var region = randi() % 4  # 0 = above, 1 = below, 2 = left, 3 = right

	match region:
		0:  # Above the viewport
			return Vector2(
				rng.randf_range(min_x, max_x),  # Random x within horizontal bounds
				min_y - margin            # Fixed y above the viewport
			)
		1:  # Below the viewport
			return Vector2(
				rng.randf_range(min_x, max_x),  # Random x within horizontal bounds
				max_y + margin            # Fixed y below the viewport
			)
		2:  # To the left of the viewport
			return Vector2(
				min_x - margin,           # Fixed x left of the viewport
				rng.randf_range(min_y, max_y)  # Random y within vertical bounds
			)
		3:  # To the right of the viewport
			return Vector2(
				max_x + margin,           # Fixed x right of the viewport
				rng.randf_range(min_y, max_y)  # Random y within vertical bounds
			)
			
	return Vector2(-margin,-margin)
