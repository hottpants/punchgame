extends Node2D
class_name ShopItem

## SIGNALS

signal decrease_money(item_id, shop_id)

## NODES

@onready var label = $ItemBox/ItemName
@onready var button = $ItemBox/BuyButton
@onready var item_container = $ItemBox

## INFORMATION VARS

@export var item_name : String
@export var cost : int
@export var description : String
var shop_id : int
var item_id : int

# Sets the data of this item to the stats received from the call of this function
func _set_stats(new_name : String, new_cost : int, new_description : String, new_id : int, new_shop_id : int):
	item_name = new_name
	cost = new_cost
	description = new_description
	item_id = new_id
	shop_id = new_shop_id

# Returns shop id
func _get_shop_id():
	return shop_id

# Returns name
func _get_name():
	return item_name

# Returns item id
func _get_id():
	return item_id

# Marks item as having already been bought
func buy_item():
	
	# Kills button
	
	button.queue_free()
	
	# Sets label color to green
	
	label.add_theme_color_override("font_color",Color("1ad633"))

# Sets physical appearance to match item (label, position, tooltip, and eventually sprite)
func build_item(y : int):
	
	# Sets tooltip of button
	
	button.set_tooltip_text(description)
	
	# Sets label text to display item name and cost
	
	label.text = item_name + " | Cost: $" + str(cost) + "       "
	
	# Sets location
	
	position = Vector2(50, y)

# Called when buy button is pressed
func _on_buy_button_pressed() -> void:
	
	# Emits signal to decrease money and buy item
	
	decrease_money.emit(item_id, shop_id)
