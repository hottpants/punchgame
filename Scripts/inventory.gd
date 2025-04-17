extends Node2D

@onready var container = $ColorRect2/ColorRect/HBoxContainer
var item_list : Array

func add_item(item : Dictionary):
	var new_item_label = Label.new()
	new_item_label.text = item["Name"]
	container.add_child(new_item_label)
	item_list.append(item)

func get_inventory():
	return item_list

func set_inventory(_item_list : Array):
	for i in _item_list:
		add_item(i)
