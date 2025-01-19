extends Node2D
class_name Piece

@export var piece_data: PieceData


# util functions
func get_readable_name():
	return (piece_data.piece_colour + " " + piece_data.piece_name).capitalize()


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

func calculate_moves(board: Dictionary, position: Vector2i):
	print("caulcuating moves")
	var valid_moves = []
	for moveset in $Movement.get_children():
		for move in moveset.calculate_moves(board, position):
			if move not in valid_moves:
				valid_moves.append(move)
	return valid_moves

func get_taken():
	queue_free()
	

# class for basic piece
# contains code for common functionality such as:
# - being moved
# - being taken
