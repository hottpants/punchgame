extends Control

@onready var pay_label = $Background/VBoxContainer/PayoutLabel
@onready var bonus_label = $Background/VBoxContainer/BonusLabel
@onready var total_label = $Background/VBoxContainer/TotalLabel

# Called when player wins a round, manages some end_of_round scene stuff
func on_win(payout : int, stage : int):
	
	var total_payout = int(payout * stage * $"../Player".get_payout_multiplier())
	
	# Sets text on payout
	
	pay_label.text = ("Payout:                   $" + str(payout*stage))
	
	# Sets text on bonus
	
	# If there is no bonus, don't set it, delete it
	if $"../Player".get_payout_multiplier() > 1:
		bonus_label.text = ("Bonuses:                 $" + str(total_payout-(payout*stage)))
	else:
		bonus_label.queue_free()
	
	# Sets text on total
	
	total_label.text = ("Total:                       $" + str(total_payout))
	
	# Pay the player
	
	$"../Player".pay(total_payout)

# Continue button
func _on_button_pressed() -> void:
	
	# Increase stage by 1 (possibly more for specific enemies/conditions/etc. in the future)
	
	$"../Player".increase_stage()
	
	# KILLS SELF TEEHEE
	
	self.queue_free()
	
