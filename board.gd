extends Node
class_name Board

## Dictionary with keys Vector2i of board state
var board = {}

## Constructs game board from parameters
func create_board(
	board_x: int = 8,
	board_y: int = 8,
	board_max_x: int = 64,
	board_max_y: int = 64
):
	
	for x in range(board_max_x):
		for y in range(board_max_y):
			# fill array with empty spaces
			board[Vector2i(x, y)] = {
				"tile": false
			}
			
	# offset board to place in centre of max board size
	var board_x_offset = floor(board_max_x / 2) - floor(board_x / 2) - 1
	var board_y_offset = floor(board_max_y / 2) - floor(board_y / 2) - 1
	
	# add tiles to board dict
	for x in range(board_x_offset, board_x_offset + board_x):
		for y in range(board_y_offset, board_y_offset + board_y):
			var coords = Vector2i(x, y)
			board[coords] = {
				"tile": true,
				"piece": null
			}

func add_tile(position: Vector2i) -> void:
	if not tile_exists(position):
		board[position] = {
			"tile": true,
			"piece": null
		}

func add_piece(resource_name: String, position: Vector2i):
	var piece = preload("res://data/piece.tscn").instantiate()
	piece.set_piece_data(load("res://data/pieces/resources/" + resource_name + ".tres"))
	add_child(piece)
	piece.name = piece.get_readable_name() + " _" + piece.name# unique name for debugging
	board[position]["piece"] = piece

func calculate_moves(position: Vector2i) -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = get_piece(position).calculate_moves(position)
	return valid_moves

func move_piece(position: Vector2i, destination: Vector2i) -> bool:
	# check if tile is valid - should never happen as is checked when this function is called
	if not tile_exists(destination):
		return false
	# if destination has piece
	if tile_full(destination):
		var captured = capture_piece(position, destination)
		# if capture is unsuccessful
		if not captured:
			return false
	
	# if destination is empty OR has a capturable piece
	board[destination]["piece"] = board[position]["piece"]
	board[position]["piece"] = null
	# call piece.move() (e.g. to disable pawn double move)
	board[destination]["piece"].move()
	return true


## check if piece can be captured
## if yes, remove piece and return true
## if no, do nothing and return false
func capture_piece(source: Vector2i, position: Vector2i) -> bool:
	# test for same colour/friendly fire
	board[position]["piece"].queue_free()
	return true


func get_all_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for position in board.keys():
		if board[position]["tile"]:
			tiles.append(position)
	return tiles

func get_all_pieces() -> Array:
	var pieces = []
	for position in get_all_tiles():
		if tile_full(position):
			pieces.append({
				"position": position,
				"piece": get_piece(position)
			})
	return pieces

func get_piece(position: Vector2i) -> Piece:
	if tile_full(position):
		return board[position]["piece"]
	else:
		return null

## Return `true` if position is within max board size
func position_valid(position: Vector2i) -> bool:
	return board.has(position)

## Return `true` if position has a tile
func tile_exists(position: Vector2i) -> bool:
	if position_valid(position):
		return board[position]["tile"]
	else:
		return false

## Return `true` if position has a tile AND has a piece on it
func tile_full(position: Vector2i) -> bool:
	if tile_exists(position):
		if board[position]["piece"] != null:
			return true
		else:
			return false
	else:
		return false
