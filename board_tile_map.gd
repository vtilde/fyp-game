extends TileMapLayer

signal tile_clicked(position: Vector2i)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var tile_position = local_to_map(make_input_local(event).position)
		tile_clicked.emit(tile_position)
