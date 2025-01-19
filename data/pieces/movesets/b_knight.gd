extends Node

# Knight
func calculate_moves(board: Dictionary, position: Vector2i):
	var valid_moves = []
	for direction in [
			Vector2i(-1, -2), Vector2i(1, -2),
			Vector2i(-1, 2), Vector2i(1, 2),
			Vector2i(-2, -1), Vector2i(-2, 1),
			Vector2i(2, -1), Vector2i(2, 1)
		]:
		var destination = position + direction
		if board.has(destination) and board[destination]["tile"]:
			valid_moves.append(destination)
	
	return valid_moves
