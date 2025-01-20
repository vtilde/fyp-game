extends Node2D
class_name Piece

var piece_data: PieceData

var moved: bool = false

# util functions
func get_readable_name() -> String:
	return (piece_data.piece_colour + " " + piece_data.piece_name).capitalize()
func get_colour() -> String:
	return piece_data.piece_colour

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
	for moveset in $Movement.get_children():
		for move in moveset.calculate_moves(position):
			if move not in valid_moves:
				valid_moves.append(move)
	return valid_moves

#func calculate_moves(board: Dictionary, position: Vector2i, rules: Dictionary):
	#print("caulcuating moves")
	#var valid_moves = []
	#for moveset in $Movement.get_children():
		#for move in moveset.calculate_moves(board, position, rules):
			#if move not in valid_moves:
				#valid_moves.append(move)
	#return valid_moves

func move():
	moved = true

func get_taken():
	queue_free()
	

# class for basic piece
# contains code for common functionality such as:
# - being moved
# - being taken
