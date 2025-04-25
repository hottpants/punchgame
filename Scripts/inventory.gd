extends Node2D

## SIGNALS

signal item_sold(item_list)

## NODES

@onready var container = $ColorRect2/ColorRect # The container in which item labels are stored

## ITEM VARS

var item_list : Array # The array where items are stored
var item_object_list : Array

## SCENE VARS

@onready var inventory_item_scene = load("res://Scenes/inventory_item.tscn")

# Adds item dictionary to inventory
func add_item(item : Dictionary):
	
	# Create new label to represent inventory item
	
	var new_item = inventory_item_scene.instantiate()
	
	# Set label text equal to the name of the being added item
	
	new_item.init_item(item)
	
	# Add the new item label as a child of container
	
	container.add_child(new_item)
	
	if item_object_list.size() >= 1:
		var locate = item_object_list[item_object_list.size()-1].position.x + item_object_list[item_object_list.size()-1].size.x + 10
		new_item.position = Vector2(locate, 0)
	# Add item to item_list
	
	item_list.append(item)
	
	new_item.item_sold.connect(remove_item)
	
	item_object_list.append(new_item)

func remove_item(item):
	item_object_list.pop_at(item_list.find(item))
	item_list.pop_at(item_list.find(item))
	print(str(item_list))
	#item_list.resize(item_list.size()-1)
	item_sold.emit(item_list)
	print(item["Name"])


# Returns item_list
func get_inventory():
	return item_list

# Sets inventory equal to _item_list. Called by shop.gd after inventory is created
func set_inventory(_item_list : Array):
	for i in _item_list: # Call add_item while passing each item from _item_list
		add_item(i)
