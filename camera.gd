extends Camera2D

#var dragging = false
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("rclick"):
		#dragging = true
	#elif Input.is_action_just_released("rclick"):
		#dragging = false
	#
	#if Input.is
	#pass

var dragging = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("rclick"):
		dragging = true
	elif event.is_action_released("rclick"):
		dragging = false
	
	if dragging and event is InputEventMouseMotion:
		self.position -= event.relative / self.zoom
