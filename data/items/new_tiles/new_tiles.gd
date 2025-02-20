extends Item

var layout: Array[Vector2i]

var layouts = {
	"0001": [Vector2i(0, 0)],
	"0101": [Vector2i(0, 0), Vector2i(0, -1)],
	"0011": [Vector2i(0, 0), Vector2i(-1, 0)],
	"1001": [Vector2i(0, 0), Vector2i(-1, -1)],
	"0110": [Vector2i(-1, 0), Vector2i(0, -1)],
	"1110": [Vector2i(0, -1), Vector2i(-1, 0), Vector2i(-1, -1)],
	"1011": [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, -1)],
	"1101": [Vector2i(0, 0), Vector2i(0, -1), Vector2i(-1, -1)],
	"0111": [Vector2i(0, 0), Vector2i(0, -1), Vector2i(-1, 0)],
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
	# return false if any position already has a tile
	for new_tile in layout:
		var board_position = position + new_tile
		if Global.board.tile_exists(board_position):
			return false
	
	# if valid, create tiles and return true
	for new_tile in layout:
		var board_position = position + new_tile
		Global.board.add_tile(board_position)
	queue_free()
	return true
