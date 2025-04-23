extends Node2D

## NODES

@onready var container = $ColorRect2/ColorRect/HBoxContainer # The container in which item labels are stored

## ITEM VARS

var item_list : Array # The array where items are stored


# Adds item dictionary to inventory
func add_item(item : Dictionary):
	
	# Create new label to represent inventory item
	
	var new_item_label = Label.new()
	
	# Set label text equal to the name of the being added item
	
	new_item_label.text = item["Name"]
	
	# Add the new item label as a child of container
	
	container.add_child(new_item_label)
	
	# Add item to item_list
	
	item_list.append(item)

# Returns item_list
func get_inventory():
	return item_list

# Sets inventory equal to _item_list. Called by shop.gd after inventory is created
func set_inventory(_item_list : Array):
	for i in _item_list: # Call add_item while passing each item from _item_list
		add_item(i)
