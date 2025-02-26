extends Node2D

@export var board_x = 8
@export var board_y = 8

@export var board_max_x = 64
@export var board_max_y = 64

@export var starting_player: Player

# set up game
var board: Board
var turn_number: int = 0
var player_turn: Player
enum Phase{
	ITEM,
	MOVE
}
var turn_phase: Phase = Phase.MOVE

var selected_tile = null
var selected_item: Item = null
var selected_item_preview: Array[Vector2i] = []

var rules = {
	"friendly_fire" = false, # true: pieces can take pieces of the same colour
	"pawn_double_require_first_move" = true, # true: pawns can only move 2 spaces on their first move
	"pawn_double_require_2nd_rank" = false # true: pawns can only move 2 spaces from their 2nd rank 
}

var items: Array[Resource] = [
	preload("res://data/items/new_tiles/new_tiles.tscn"),
	preload("res://data/items/destroy_tiles/destroy_tiles.tscn")
]

func _ready() -> void:
	# setup board
	board = $Board
	board.create_board(board_x, board_y, board_max_x, board_max_y)
	
	Global.board = board
	Global.rules = rules
	
	# white
	for i in range(27, 35):
		board.add_piece("White", "w_pawn", Vector2i(i, 33))
	board.add_piece("White", "w_rook", Vector2i(27, 34))
	board.add_piece("White", "w_knight", Vector2i(28, 34))
	board.add_piece("White", "w_bishop", Vector2i(29, 34))
	board.add_piece("White", "w_queen", Vector2i(30, 34))
	board.add_piece("White", "w_king", Vector2i(31, 34))
	board.add_piece("White", "w_bishop", Vector2i(32, 34))
	board.add_piece("White", "w_knight", Vector2i(33, 34))
	board.add_piece("White", "w_rook", Vector2i(34, 34))
	
	# black
	for i in range(27, 35):
		board.add_piece("Black", "b_pawn", Vector2i(i, 28))
	board.add_piece("Black", "b_rook", Vector2i(27, 27))
	board.add_piece("Black", "b_knight", Vector2i(28, 27))
	board.add_piece("Black", "b_bishop", Vector2i(29, 27))
	board.add_piece("Black", "b_queen", Vector2i(30, 27))
	board.add_piece("Black", "b_king", Vector2i(31, 27))
	board.add_piece("Black", "b_bishop", Vector2i(32, 27))
	board.add_piece("Black", "b_knight", Vector2i(33, 27))
	board.add_piece("Black", "b_rook", Vector2i(34, 27))
	
	board.get_node("ItemPreviewTileMap").set_cell(Vector2i(30, 31), 0, Vector2i(0, 0))
	#$ItemPreviewTileMap.set_cell(Vector2i(30, 31), 0, Vector2i(0, 0))
	# set player turn
	start_turn(starting_player)
	
	render_board()
	centre_camera()


func render_board():
	# clear valid moves indicators
	board.get_node("MoveDisplayTileMap").clear()
	
	# clear all tiles (to update removed tiles)
	board.get_node("BoardTileMap").clear()
	
	# tileset coords for tile sprites
	var tile_black = Vector2i(0, 0)
	var tile_white = Vector2i(1, 0)
	
	for position in board.get_all_tiles():
		# checkerboard pattern (even coords sum = white tile)
		if (position.x + position.y) % 2 == 0:
			board.get_node("BoardTileMap").set_cell(position, 0, tile_white)
		else:
			board.get_node("BoardTileMap").set_cell(position, 0, tile_black)
	
	for piece in board.get_all_pieces():
		piece["piece"].position = board.get_node("BoardTileMap").map_to_local(piece["position"])

func centre_camera():
	var camera = board.get_node("Camera")
	camera.zoom = Vector2(0.6, 0.6)
	#camera.zoom = Vector2(0.1, 0.1)
	camera.position.x = ((board_max_x / 2) - 1) * 128
	camera.position.y = ((board_max_y / 2) - 1) * 128


func _on_tile_hovered(position: Vector2i) -> void:
	board.get_node("ItemPreviewTileMap").clear()
	if len(selected_item_preview) != 0:
		for tile in selected_item_preview:
			board.get_node("ItemPreviewTileMap").set_cell(position + tile, 0, Vector2i(0,0))



# manage game flow
func start_turn(turn: Player = null) -> void:
	if turn == null:
		# next turn by default
		match player_turn.colour:
			"black":
				player_turn = $GUI/Players/White
			"white":
				player_turn = $GUI/Players/Black
	else:
		# if specified, start that player's turn (e.g. start of game)
		player_turn = turn
	
	$GUI.set_player_turn(player_turn)
	if player_turn == starting_player:
		turn_number += 1
	$GUI.set_turn_number(turn_number)
	
	# give item every other turn
	if turn_number % 2 == 0:
		add_item(player_turn, items.pick_random().instantiate())
	
	# start item phase
	start_item_phase()

func start_item_phase() -> void:
	if len(player_turn.get_items()) <= 0:
		# skip phase if player has no items
		start_move_phase()
	else:
		# set to item phase
		turn_phase = Phase.ITEM
		player_turn.show_items()
		$GUI.set_turn_phase(["item", "move"][turn_phase])
		$GUI.show_skip_item_button()

func _on_item_phase_skipped() -> void:
	start_move_phase()

func start_move_phase() -> void:
	turn_phase = Phase.MOVE
	player_turn.hide_items()
	$GUI.set_turn_phase(["item", "move"][turn_phase])
	$GUI.hide_skip_item_button()

func check_win(player: Player):
	if player.colour == "white":
		if board.player_lost("Black"):
			$GUI.show_win_screen(player)
	elif player.colour == "black":
		if board.player_lost("White"):
			$GUI.show_win_screen(player)


func _on_tile_clicked(position: Vector2i) -> void:
	if turn_phase == Phase.ITEM and selected_item != null:
		var item_success = selected_item.use(position)
		if item_success:
			print("used item")
			render_board()
			start_move_phase()
		
	elif turn_phase == Phase.MOVE:
		if selected_tile == null:
			select_piece(position)
		else:
			move_piece(position)



# manage player items
func add_item(player: Player, item: Item):
	var success = player.add_item(item)
	if success:
		item.item_selected.connect(_on_item_selected)
		item.item_deselected.connect(_on_item_deselected)

func _on_item_selected(item: Item):
	# deselect all other items if one is selected
	for i in player_turn.get_items():
		if i != item:
			i.deselect()
	selected_item = item
	
	# show preview over cursor
	selected_item_preview = selected_item.get_preview()

func _on_item_deselected(item: Item):
	selected_item = null
	selected_item_preview = []
	board.get_node("ItemPreviewTileMap").clear()


# select and move pieces
func select_piece(clicked_tile: Vector2i):
	if board.tile_full(clicked_tile):
		var piece = board.get_piece(clicked_tile) as Piece
		if piece.get_colour() == player_turn.colour:
			var moves = board.calculate_moves(clicked_tile)
			if len(moves) != 0:
				selected_tile = clicked_tile
				display_moves(moves)

func display_moves(valid_moves):
	for tile in valid_moves:
		board.get_node("MoveDisplayTileMap").set_cell(tile, 0, Vector2i(0,0))

func move_piece(clicked_tile: Vector2i):
	# clicked invalid -> cancel
	if board.get_node("MoveDisplayTileMap").get_cell_tile_data(clicked_tile) == null:
		selected_tile = null
	# clicked valid ->
	else:
		var move_successful = board.move_piece(selected_tile, clicked_tile)
		if move_successful:
			# check if game was won
			var player_win = check_win(player_turn)
			if player_win:
				print("player won")
			else:
				start_turn()
	
	# deselect tile (includes moving and cancelling)
	selected_tile = null
	render_board()

func take_piece(position):
	if board[position]["piece"] != null:
		remove_child(board[position]["piece"])
		board[position]["piece"].queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
