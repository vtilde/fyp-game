extends Control
class_name Item

signal item_selected(item: Item)
signal item_deselected(item: Item)

var selected: bool = false
@export var select_offset: int = 40

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		print("item clicked")
		print(get_parent().get_parent().colour)
		if not selected:
			select()
		else:
			deselect()

#func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	#if event.is_action_pressed("click"):
		#if not selected:
			#select()
		#else:
			#deselect()
		#get_viewport().set_input_as_handled()

func select():
	selected = true
	position.y -= select_offset
	item_selected.emit(self)

func deselect():
	if selected:
		selected = false
		position.y += select_offset
		item_deselected.emit(self)

## return list of Vector2i of tiles to show ghost ((0,0) at cursor)
func get_preview() -> Array[Vector2i]:
	return [Vector2i(0, 0)]

func use(position: Vector2i) -> bool:
	return false
