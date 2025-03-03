extends Camera2D

var dragging: bool = false
var zoom_factor: Vector2 = Vector2(0.02, 0.02)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("rclick"):
		dragging = true
	elif event.is_action_released("rclick"):
		dragging = false
	
	if dragging and event is InputEventMouseMotion:
		self.position -= event.relative / self.zoom

	if event.is_action_pressed("zoom_in"):
		self.zoom += zoom_factor
	if event.is_action_pressed("zoom_out"):
		self.zoom -= zoom_factor
