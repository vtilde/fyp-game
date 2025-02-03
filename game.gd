extends Node2D

@export var board_x = 8
@export var board_y = 8

@export var board_max_x = 64
@export var board_max_y = 64


# set up game
var board: Board
var player_turn = "white"
enum Phase{
	ITEM,
	MOVE
}
var turn_phase: Phase = Phase.MOVE



var selected_tile = null
var selected_item = null

var rules = {
	"friendly_fire" = false, # true: pieces can take pieces of the same colour
	"pawn_double_require_first_move" = true, # true: pawns can only move 2 spaces on their first move
	"pawn_double_require_2nd_rank" = false # true: pawns can only move 2 spaces from their 2nd rank 
}

func _ready() -> void:
	board = $Board
	board.create_board(board_x, board_y, board_max_x, board_max_y, rules)
	
	Global.board = board
	Global.rules = rules
	
	# default board setup
	# white
	for i in range(27, 35):
		board.add_piece("w_pawn", Vector2i(i, 33))
	board.add_piece("w_rook", Vector2i(27, 34))
	board.add_piece("w_knight", Vector2i(28, 34))
	board.add_piece("w_bishop", Vector2i(29, 34))
	board.add_piece("w_queen", Vector2i(30, 34))
	board.add_piece("w_king", Vector2i(31, 34))
	board.add_piece("w_bishop", Vector2i(32, 34))
	board.add_piece("w_knight", Vector2i(33, 34))
	board.add_piece("w_rook", Vector2i(34, 34))
	
	# black
	for i in range(27, 35):
		board.add_piece("b_pawn", Vector2i(i, 28))
	board.add_piece("b_rook", Vector2i(27, 27))
	board.add_piece("b_knight", Vector2i(28, 27))
	board.add_piece("b_bishop", Vector2i(29, 27))
	board.add_piece("b_queen", Vector2i(30, 27))
	board.add_piece("b_king", Vector2i(31, 27))
	board.add_piece("b_bishop", Vector2i(32, 27))
	board.add_piece("b_knight", Vector2i(33, 27))
	board.add_piece("b_rook", Vector2i(34, 27))
	
	
	$GUI.set_player_turn(player_turn)
	$GUI.set_turn_phase(turn_phase)
	
	render_board()
	centre_camera()
	
	add_item("new_tiles")


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
		piece["piece"].position = $BoardTileMap.map_to_local(piece["position"])

func centre_camera():
	var camera = $Camera
	camera.zoom = Vector2(0.6, 0.6)
	camera.position.x = ((board_max_x / 2) - 1) * 128
	camera.position.y = ((board_max_y / 2) - 1) * 128


func add_item(item_path: String):
	var new_item = load("res://data/items/" + item_path + ".tscn").instantiate() as Item
	add_child(new_item)
	new_item.position = Vector2i(3500, 3500)
	print(new_item.get_preview())


func _on_item_selected():
	pass




func _on_tile_clicked(position: Vector2i) -> void:
	if turn_phase == Phase.MOVE:
		if selected_tile == null:
			select_piece(position)
		else:
			move_piece(position)

#func _input(event):
	#if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		#if turn_phase == Phase.ITEM:
			#pass
		#elif turn_phase == Phase.MOVE:
			## get tilemap coords based on click location (including zoom)
			#print("clicked grid ", $BoardTileMap.local_to_map($BoardTileMap.make_input_local(event).position))
			#var tile_position = $BoardTileMap.local_to_map($BoardTileMap.make_input_local(event).position)
			#if selected_tile == null:
				#select_piece(tile_position)
			#else:
				#move_piece(tile_position)

# show items
func show_items(player: String):
	pass

func clear_items():
	pass


# select and move piece
func select_piece(clicked_tile: Vector2i):
	if board.tile_full(clicked_tile):
		var piece = board.get_piece(clicked_tile) as Piece
		if piece.get_colour() == player_turn:
			var moves = board.calculate_moves(clicked_tile)
			if len(moves) != 0:
				selected_tile = clicked_tile
				display_moves(moves)

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

func take_piece(position):
	if board[position]["piece"] != null:
		remove_child(board[position]["piece"])
		board[position]["piece"].queue_free()


# manage game flow
func change_phase():
	match turn_phase:
		Phase.ITEM:
			turn_phase = Phase.MOVE
		Phase.MOVE:
			change_turn()
			turn_phase = Phase.ITEM

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
