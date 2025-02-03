extends Area2D
class_name Item

signal item_selected(item: Item)
signal item_deselected(item: Item)

var selected: bool = false

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		if not selected:
			selected = true
			position.y -= 128
			item_selected.emit(self)
			print("selected")
		else:
			selected = false
			position.y += 128
			item_deselected.emit(self)
			print("deselected")

## return list of Vector2i of tiles to show ghost ((0,0) at cursor)
func get_preview() -> Array[Vector2i]:
	return []

func use(position: Vector2i) -> bool:
	return false
