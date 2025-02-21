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

func show_win_screen(player: Player) -> void:
	$WinScreen.visible = true
	$WinScreen.text = player.colour + " wins"
