extends Node

# Black Pawn
func calculate_moves(board: Dictionary, position: Vector2i, rules: Dictionary):
	var valid_moves = []
	
	# allow move 1 space if tile exists and is empty
	var single = position + Vector2i(0, -1)
	if board.has(single) and board[single]["tile"] != null and board[single]["piece"] == null:
		valid_moves.append(single)
	
	# allow move 2 spaces based on game rules
	var double = position + Vector2i(0, -2)
	if validate_double(rules):
		if board.has(double) and board[double]["tile"] != null and board[double]["piece"] == null:
			valid_moves.append(double)
	
	# taking diagonals
	for i in [Vector2i(-1, -1), Vector2i(1, -1)]:
		var diagonal = position + i
		if board.has(diagonal) and board[diagonal]["tile"] != null and board[diagonal]["piece"] != null:
			valid_moves.append(diagonal)

	return valid_moves

func validate_double(rules: Dictionary):
	if rules["pawn_double_require_first_move"] and get_parent().get_parent().moved:
		return false
	return true
