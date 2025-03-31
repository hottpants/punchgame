extends Node2D
class_name ShopItem

signal decreaseMoney(itemName, cost)

@export var item_name : String
@export var label : Label
@export var cost : int
@export var button : Button
@export var item_container : HBoxContainer
@export var description : String

func _ready() -> void:
	item_name = ""
	pass

func _set_stats(new_name : String, new_cost : int, new_description : String):
	item_name = new_name
	cost = new_cost
	description = new_description

func _get_name():
	return item_name

func _build_object(x: int, y: int):
	item_container = HBoxContainer.new()
	add_child(item_container)
	label = Label.new()
	button = Button.new()
	item_container.add_child(label)
	item_container.set_alignment(BoxContainer.ALIGNMENT_BEGIN)
	label.set_h_size_flags(2)
	
	item_container.add_child(button)
	button.pressed.connect(_on_button_pressed)
	button.text = "BUY"
	button.set_tooltip_text(description)
	item_container.set_size(Vector2(340,32))
	label.text = item_name + " | Cost: $" + str(cost) + "       "
	position = Vector2(x,y)
	
func _on_button_pressed() -> void:
	decreaseMoney.emit(item_name, cost)
