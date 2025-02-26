extends Item

var layout: Array[Vector2i]

var layouts = {
	"0001": [Vector2i(0, 0)],
	"0011": [Vector2i(0, 0), Vector2i(-1, 0)],
	"0101": [Vector2i(0, 0), Vector2i(0, -1)],
	"1111": [Vector2i(0, 0), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(-1, -1)]
}

func _ready() -> void:
	var layout_key = layouts.keys().pick_random()
	layout.assign(layouts[layout_key])
	get_node("Icon" + layout_key).visible = true

## return list of tiles to place (cursor at bottom right)
func get_preview() -> Array[Vector2i]:
	return layout

func use(position: Vector2i) -> bool:
	# can use if there is at least one valid tile and no pieces in item area
	var valid_tile = false
	for new_tile in layout:
		var board_position = position + new_tile
		if Global.board.tile_exists(board_position):
			valid_tile = true
		if Global.board.tile_full(board_position):
			print("destroy has piece")
			return false # interrupt and return false if any tile in area has piece on it
	
	# return false if no tiles exist in item area
	if not valid_tile:
		print("destroy has no tiles")
		return false
	
	# else, delete all tiles in area and return true
	for new_tile in layout:
		var board_position = position + new_tile
		Global.board.remove_tile(board_position)
	queue_free()
	print("destroyed")
	return true
