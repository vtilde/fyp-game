extends Control
class_name Player

@export var colour: String
@export var max_items: int = 5

var items: Array[Item]

func _ready() -> void:
	if max_items < 0:
		max_items = 0
	hide_items()

func add_item(item: Item) -> bool:
	if len(items) + 1 <= max_items:
		items.append(item)
		$Items.add_child(item)
		return true
	else:
		return false

func deselect_all_items() -> void:
	for item in items:
		item.deselect()

func show_items() -> void:
	deselect_all_items()
	$Items.visible = true

func hide_items() -> void:
	deselect_all_items()
	$Items.visible = false
