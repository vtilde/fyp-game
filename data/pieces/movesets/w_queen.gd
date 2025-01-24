extends Node

# Queen
func calculate_moves(position: Vector2i) -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	for direction in [
			Vector2i(0, -1),  # N
			Vector2i(0, 1),   # S
			Vector2i(-1, 0),  # W
			Vector2i(1, 0),   # E
			Vector2i(-1, -1), # NW
			Vector2i(1, -1),  # NE
			Vector2i(-1, 1),  # SW
			Vector2i(1, 1)    # SE
	]:
		var current_tile = position
		var moving = true
		while moving:
			current_tile += direction
			if Global.board.tile_exists(current_tile):
				# add valid move if tile exists
				valid_moves.append(current_tile)
				if Global.board.tile_full(current_tile):
					# if tile has piece, stop moving in this direction
					moving = false
			else:
				moving = false
		
	return valid_moves
