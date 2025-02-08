extends Area2D
class_name Item

signal item_selected(item: Item)
signal item_deselected(item: Item)

var selected: bool = false

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		if not selected:
			select()
		else:
			deselect()

func select():
	selected = true
	position.y -= 128
	item_selected.emit(self)

func deselect():
	if selected:
		selected = false
		position.y += 128
		item_deselected.emit(self)


## return list of Vector2i of tiles to show ghost ((0,0) at cursor)
func get_preview() -> Array[Vector2i]:
	return [Vector2i(0, 0)]

func use(position: Vector2i) -> bool:
	return false
