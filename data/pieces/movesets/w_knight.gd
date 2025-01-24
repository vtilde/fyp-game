extends Node

# Knight
func calculate_moves(position: Vector2i) -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	for direction in [
			Vector2i(-1, -2), Vector2i(1, -2), # NNW, NNE
			Vector2i(-1, 2), Vector2i(1, 2),   # SSW, SSE
			Vector2i(-2, -1), Vector2i(-2, 1), # WWN, WWS
			Vector2i(2, -1), Vector2i(2, 1)    # EEN, EES
		]:
		var destination = position + direction
		if Global.board.tile_exists(destination):
			valid_moves.append(destination)
	
	return valid_moves
