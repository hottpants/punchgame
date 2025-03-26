extends Node2D
class_name ShopItem

signal decreaseMoney(itemName, cost)

@export var itemName : String
@export var label : Label
@export var cost : int
@export var button : Button

func _ready() -> void:
	pass
	

func _set_stats(new_name : String, new_cost : int):
	itemName = new_name
	cost = new_cost
	label.text = itemName + " | Cost: $" + str(cost) + "       "



	
	


func _on_buy_button_pressed() -> void:
	decreaseMoney.emit(itemName, cost)
