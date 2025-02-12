extends TileMapLayer

signal tile_hovered(position: Vector2i)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var tile_position = local_to_map(make_input_local(event).position)
		tile_hovered.emit(tile_position) 
