extends Node

# King
func calculate_moves(position: Vector2i) -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	for direction in [
			Vector2i(-1, -1), # NW
			Vector2i(0, -1),  # N
			Vector2i(1, -1),  # NE
			Vector2i(-1, 0),  # W
			Vector2i(1, 0),   # E
			Vector2i(-1, 1),  # SW
			Vector2i(0, 1),   # S
			Vector2i(1, 1)    # SE
		]:
		var destination = position + direction
		if Global.board.tile_exists(destination):
			valid_moves.append(destination)
	
	return valid_moves
