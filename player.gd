extends Node2D
class_name Player

@export var colour: String
@export var max_items: int = 5

var items: Array[Item]

func _ready() -> void:
	if max_items < 0:
		max_items = 0
	
	var viewport = get_viewport_rect().size
	$Items.offset = Vector2(0, viewport.y)
	hide_items()


func add_item(item: Item) -> bool:
	if len(items) + 1 <= max_items:
		items.append(item)
		$Items.add_child(item)
		return true
	else:
		return false

func show_items() -> void:
	var viewport = get_viewport_rect().size
	var item_spacing = viewport.x / (len(items) + 1)
	for i in range(len(items)):
		items[i].position = Vector2(item_spacing * (i + 1), 0)
	$Items.visible = true

func hide_items() -> void:
	$Items.visible = false
