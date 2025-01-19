extends Node

# Rook
func calculate_moves(board: Dictionary, position: Vector2i):
	var valid_moves = []
	for direction in [
			Vector2i(0, -1),
			Vector2i(0, 1),
			Vector2i(-1, 0),
			Vector2i(1, 0)
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
