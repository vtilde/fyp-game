extends Item

@export var max_x: int = 3
@export var max_y: int = 3
@export var tile_chance: float = 0.3
@export var min_tiles: int = 1

var layout: Array[Vector2i]

func _ready() -> void:
	for x in max_x:
		for y in max_y:
			if randf() < tile_chance:
				layout.append(Vector2i(x, y))
	# add random tile if below minimum
	while len(layout) < min_tiles:
		layout.append(Vector2i(randi() % max_x, randi() % max_y))

## return list of tiles to place (cursor at top left)
func get_preview() -> Array[Vector2i]:
	return layout

func use(position: Vector2i) -> bool:
	# return false if any position already has a tile
	for new_tile in layout:
		var board_position = position + new_tile
		if Global.board.tile_exists(board_position):
			return false
	
	# if valid, create tiles and return true
	for new_tile in layout:
		var board_position = position + new_tile
		Global.board.add_tile(board_position)
	return true
