extends Control

# Called when player wins a round, manages some end_of_round scene stuff
func on_win(payout : int, stage : int):
	
	# Sets text on payout in end_of_round scene
	
	$Background/PayoutLabel.text = ("Payout:                   $" + str(payout * stage))
	
	# Pay the player
	
	$"../Player".pay(payout*stage)

# Continue button
func _on_button_pressed() -> void:
	
	# Increase stage by 1 (possibly more for specific enemies/conditions/etc. in the future)
	
	$"../Player".increase_stage()
	
	# KILLS SELF TEEHEE
	
	self.queue_free()
	
