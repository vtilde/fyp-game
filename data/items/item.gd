extends Area2D

#@export var max_x: int = 3
#@export var max_y: int = 3
#@export var tile_chance: float = 0.3
#@export var min_tiles: int = 1
#
#var layout: Array[Vector2i]
#
#func _ready() -> void:
	#for x in max_x:
		#for y in max_y:
			#if randf() < tile_chance:
				#layout.append(Vector2i(x, y))
	## add random tile if below minimum
	#while len(layout) < min_tiles:
		#layout.append(Vector2i(randi() % max_x, randi() % max_y))
	#print(layout)

signal item_selected

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		print("clicked")
