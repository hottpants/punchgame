extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_win(payout : int, stage : int):
	$Background/PayoutLabel.text = ("Payout:                   $" + str(payout * stage))
	$"../Player".pay(payout*stage)
	
func _on_button_pressed() -> void:
	$"../Player"._increment_stage()
	self.queue_free()
	
