extends TileMapLayer

@export var board_x = 8
@export var board_y = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(board_x):
		for y in range(board_y):
			var coords = Vector2i(x, y)
			self.set_cell(coords, 0, Vector2i(0, 0))

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var tile_position = local_to_map(event.position)
		tile_clicked(tile_position.x, tile_position.y)
		

func tile_clicked(x: int, y: int):
	print("clicked tile " + str(x) + " " + str(y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
