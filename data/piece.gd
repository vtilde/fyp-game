extends Node2D
class_name Piece

var piece_data: PieceData

var moved: bool = false

# util functions
func get_readable_name() -> String:
	return (piece_data.piece_colour + " " + piece_data.piece_name).capitalize()
func get_colour() -> String:
	return piece_data.piece_colour
func is_king() -> bool:
	return piece_data.king

# initialization functions
func set_piece_data(new_piece_data: PieceData):
	# remove existing data?
	piece_data = new_piece_data
	
	# set texture
	$Sprite.texture = piece_data.piece_sprite
	
	# add moveset scripts
	for moveset in piece_data.movesets:
		add_moveset(moveset)

func add_moveset(moveset: GDScript):
	var new_moveset_node = Node.new()
	new_moveset_node.set_script(moveset)
	$Movement.add_child(new_moveset_node)

func calculate_moves(position: Vector2i) -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	# add valid move to array for each moveset (pieces will usually only have 1)
	for moveset in $Movement.get_children():
		for move in moveset.calculate_moves(position):
			if move not in valid_moves:
				valid_moves.append(move)
	
	# if friendly fire is false, remove moves that land on piece of same colour
	if not Global.rules.get("friendly_fire", false):
		var friendly_moves: Array[Vector2i] = []
		var colour = get_colour()
		for move in valid_moves:
			# allow if tile is empty
			if not Global.board.tile_full(move):
				friendly_moves.append(move)
			else:
				# allow if tile is full and different colour to self
				if Global.board.get_piece(move).get_colour() != colour:
					friendly_moves.append(move)
		valid_moves = friendly_moves
	
	return valid_moves


func move():
	moved = true

func get_taken():
	queue_free()
