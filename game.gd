extends Node2D

@export var board_x = 8
@export var board_y = 8

@export var board_max_x = 64
@export var board_max_y = 64

var board: Board
var selected_tile = null
var player_turn = "black"

var rules = {
	"friendly_fire" = false, # true: pieces can take pieces of the same colour
	"pawn_double_require_first_move" = true, # true: pawns can only move 2 spaces on their first move
	"pawn_double_require_2nd_rank" = false # true: pawns can only move 2 spaces from their 2nd rank 
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board = $Board
	board.create_board(board_x, board_y, board_max_x, board_max_y, rules)
	
	Global.board = board
	Global.rules = rules
	
	board.add_piece("b_rook", Vector2i(27, 34))
	board.add_piece("b_rook", Vector2i(34, 34))
	board.add_piece("w_rook", Vector2i(27, 27))

	## default setup
	#add_piece("b_rook", Vector2i(28, 28))
	#add_piece("w_bishop", Vector2i(30, 28))
	#add_piece("b_knight", Vector2i(29, 30))
	#add_piece("w_rook", Vector2i(31, 32))
	#add_piece("b_queen", Vector2i(32, 32))
	#add_piece("w_king", Vector2i(33, 33))
	#add_piece("b_pawn", Vector2i(30, 33))
	
	player_turn = "black"
	
	render_board()
	centre_camera()


func render_board():
	# clear valid moves indicators
	$MoveDisplayTileMap.clear()
	
	# tileset coords for tile sprites
	var tile_black = Vector2i(0, 0)
	var tile_white = Vector2i(1, 0)
	
	for position in board.get_all_tiles():
		# checkerboard pattern (even coords sum = white tile)
		if (position.x + position.y) % 2 == 0:
			$BoardTileMap.set_cell(position, 0, tile_white)
		else:
			$BoardTileMap.set_cell(position, 0, tile_black)
	
	for piece in board.get_all_pieces():
		print(piece)
		piece["piece"].position = $BoardTileMap.map_to_local(piece["position"])

	
	#for position in board.keys():
		#if board[coords]["tile"]:
			## checkerboard pattern (even coords sum = white tile)
			#if (coords.x + coords.y) % 2 == 0:
				#$BoardTileMap.set_cell(coords, 0, tile_white)
			#else:
				#$BoardTileMap.set_cell(coords, 0, tile_black)
			#
			#if board[coords]["piece"] != null:
				#board[coords]["piece"].position = $BoardTileMap.map_to_local(coords)
	
func centre_camera():
	var camera = $Camera
	camera.zoom = Vector2(0.6, 0.6)
	camera.position.x = ((board_max_x / 2) - 1) * 128
	camera.position.y = ((board_max_y / 2) - 1) * 128


func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		print("clicked grid ", $BoardTileMap.local_to_map($BoardTileMap.make_input_local(event).position))
		# get tilemap coords based on click location (including zoom)
		var tile_position = $BoardTileMap.local_to_map($BoardTileMap.make_input_local(event).position)
		if selected_tile == null:
			select_piece(tile_position)
		else:
			move_piece(tile_position)
		
func select_piece(clicked_tile: Vector2i):
	if board.tile_full(clicked_tile):
		var piece = board.get_piece(clicked_tile) as Piece
		if piece.get_colour() == player_turn:
			selected_tile = clicked_tile
			display_moves(board.calculate_moves(selected_tile))

func display_moves(valid_moves):
	for tile in valid_moves:
		$MoveDisplayTileMap.set_cell(tile, 0, Vector2i(0,0))

func move_piece(clicked_tile: Vector2i):
	# clicked invalid -> cancel
	if $MoveDisplayTileMap.get_cell_tile_data(clicked_tile) == null:
		selected_tile = null
	# clicked valid ->
	else:
		var move_successful = board.move_piece(selected_tile, clicked_tile)
		if move_successful:
			change_turn()
	
	# deselect tile (includes moving and cancelling)
	selected_tile = null
	render_board()
	
	
	## if valid move marker is on clicked cell (aka if move is valid)
	#if $MoveDisplayTileMap.get_cell_tile_data(clicked_tile) != null:
		## check if piece exists
		#if board[clicked_tile]["piece"] != null:
			## check if piece can be taken
			#if not rules["friendly_fire"] and board[selected_tile]["piece"].piece_data.piece_colour == board[clicked_tile]["piece"].piece_data.piece_colour:
				#return
			#else:
				#selected_tile = null
				#take_piece(clicked_tile)
#
		## set destination tile to piece
		#board[clicked_tile]["piece"] = board[selected_tile]["piece"]
		## remove piece from original tile
		#board[selected_tile]["piece"] = null
		## advance game state (change turns)
		#change_turn()
#
	#selected_tile = null
	#render_board()

func take_piece(position):
	if board[position]["piece"] != null:
		remove_child(board[position]["piece"])
		board[position]["piece"].queue_free()

func change_turn():
	match player_turn:
		"black":
			player_turn = "white"
		"white":
			player_turn = "black"
	$GUI.set_player_turn(player_turn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
