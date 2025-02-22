extends CanvasLayer


func _ready() -> void:
	$WinScreen.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_turn_number(turn: int) -> void:
	$Container/TurnNumber.text = "turn number: " + str(turn)

func set_player_turn(player: Player) -> void:
	$Container/PlayerTurn.text = "turn: " + player.colour

func set_turn_phase(phase: String) -> void:
	$Container/TurnPhase.text = "phase: " + phase


signal skip_item

func show_skip_item_button() -> void:
	$SkipItemButton.visible = true

func hide_skip_item_button() -> void:
	$SkipItemButton.visible = false

func _on_skip_item_button_pressed() -> void:
	skip_item.emit()


func show_win_screen(player: Player) -> void:
	$WinScreen.visible = true
	$WinScreen.text = player.colour + " wins"
