extends Node

# White Pawn
func calculate_moves(position: Vector2i) -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	
	# allow move 1 space if tile exists and is empty
	var single = position + Vector2i(0, -1)
	if Global.board.tile_exists(single) and not Global.board.tile_full(single):
		valid_moves.append(single)
	
		# allow move 2 spaces based on game rules AND if 1 space is valid
		var double = position + Vector2i(0, -2)
		if validate_double(position):
			if Global.board.tile_exists(double) and not Global.board.tile_full(double):
				valid_moves.append(double)
	
	# taking diagonals
	for i in [Vector2i(-1, -1), Vector2i(1, -1)]:
		var diagonal = position + i
		if Global.board.tile_exists(diagonal) and Global.board.tile_full(diagonal):
			valid_moves.append(diagonal)

	return valid_moves

func validate_double(position: Vector2i) -> bool:
	var allowed = true
	if Global.rules.get("pawn_double_require_first_move", false):
		if Global.board.get_piece(position).moved:
			allowed = false
	
	return allowed
