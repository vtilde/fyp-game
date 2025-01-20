extends Node

# Queen
func calculate_moves(board: Dictionary, position: Vector2i, rules: Dictionary):
	var valid_moves = []
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
		while true:
			current_tile += direction
			if not board.has(current_tile):
				break
			elif not board[current_tile]["tile"]:
				break
			else:
				valid_moves.append(current_tile)
				if board[current_tile]["piece"] != null:
					break
	
	return valid_moves
