extends Node

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed:
		add_child(self)
		self.global_position = event.position
		
	if event is InputEventScreenTouch and not event.pressed:
		queue_free()
