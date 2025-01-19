extends Node2D

@export var board_x = 8
@export var board_y = 8

@export var board_max_x = 64
@export var board_max_y = 64

var board = {}
var selected_tile = null

# false: pieces cannot take same colour
var friendly_fire = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialise array to store board/pieces
	for x in range(board_max_x):
		for y in range(board_max_y):
			# fill array with each tile being blank
			board[Vector2i(x, y)] = {
				"tile": false
			}
	
	# offset board to place in centre of max board size
	var _board_x_offset = floor(board_max_x / 2) - floor(board_x / 2) - 1
	var _board_y_offset = floor(board_max_y / 2) - floor(board_y / 2) - 1
	
	# add board/tile data to board dict
	for x in range(_board_x_offset, _board_x_offset + board_x):
		for y in range(_board_y_offset, _board_y_offset + board_y):
			var coords = Vector2i(x, y)
			board[coords] = {
				"tile": true,
				"piece": null
			}
	
	# temp - add piece
	add_piece("b_rook", Vector2i(28, 28))
	add_piece("w_rook", Vector2i(32, 28))
	add_piece("b_bishop", Vector2i(30, 28))
	add_piece("b_knight", Vector2i(27, 34))
	
	
	render_board()
	centre_camera()

func add_piece(resource_name: String, position: Vector2i):
	var piece = preload("res://data/piece.tscn").instantiate()
	piece.set_piece_data(load("res://data/pieces/resources/" + resource_name + ".tres"))
	$BoardTileMap.add_child(piece)
	board[position]["piece"] = piece

func render_board():
	# clear valid moves indicators
	$MoveDisplayTileMap.clear()
	
	# tileset coords for tile sprites
	var tile_black = Vector2i(0, 0)
	var tile_white = Vector2i(1, 0)
	
	for coords in board.keys():
		if board[coords]["tile"]:
			# checkerboard pattern (even coords sum = white tile)
			if (coords.x + coords.y) % 2 == 0:
				$BoardTileMap.set_cell(coords, 0, tile_white)
			else:
				$BoardTileMap.set_cell(coords, 0, tile_black)
			
			if board[coords]["piece"] != null:
				board[coords]["piece"].position = $BoardTileMap.map_to_local(coords)
	
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
	if board[clicked_tile]["piece"] == null:
		return
	else:
		selected_tile = clicked_tile
		var selected_piece = board[clicked_tile]["piece"]
		print("selected " + selected_piece.get_readable_name())
		display_moves(selected_piece.calculate_moves(board, clicked_tile))
		return

func display_moves(valid_moves):
	for tile in valid_moves:
		$MoveDisplayTileMap.set_cell(tile, 0, Vector2i(0,0))
	return

func move_piece(clicked_tile: Vector2i):
	print("try move piece to " + str(clicked_tile))
	# if valid move marker is on clicked cell (aka if move is valid)
	if $MoveDisplayTileMap.get_cell_tile_data(clicked_tile) != null:
		# check if piece exists
		if board[clicked_tile]["piece"] != null:
			# check if piece can be taken
			if not friendly_fire and board[selected_tile]["piece"].piece_data.piece_colour == board[clicked_tile]["piece"].piece_data.piece_colour:
				return
			take_piece(clicked_tile)

		# set destination tile to piece
		board[clicked_tile]["piece"] = board[selected_tile]["piece"]
		# remove piece from original tile
		board[selected_tile]["piece"] = null
		# advance game state (change turns)
		# TODO
	# clear selected tile var (includes cancelling)
	selected_tile = null
	render_board()
	return

func take_piece(position):
	if board[position]["piece"] != null:
		remove_child(board[position]["piece"])
		board[position]["piece"].queue_free()
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
