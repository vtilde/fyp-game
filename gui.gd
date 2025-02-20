extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_turn_number(turn: int) -> void:
	$Container/TurnNumber.text = "turn number: " + str(turn)

func set_player_turn(player: Player) -> void:
	$Container/PlayerTurn.text = "turn: " + player.colour

func set_turn_phase(phase: String) -> void:
	$Container/TurnPhase.text = "phase: " + phase
