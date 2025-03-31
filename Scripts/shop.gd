extends Node2D

@export var cash : int

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var shop_item1 = $VBoxContainer/Item
	var shop_item2 = $VBoxContainer/Item2
	var shop_item3 = $VBoxContainer/Item3
	
	
	var items = ["balls", "peenor", "brass knuckles", "jock srap", "bong", "holy hand grenade", "gun", "baseball bat"]
	var cost = [2, 1, 25, 6, 42, 1000, 63, 17]
	var chance = [1, 1, 2, 4, 3, 4, 3, 3]
	
	
	var item1 = _pickItem(chance)
	shop_item1._set_stats(items[item1], cost[item1])
	items.remove_at(item1)
	cost.remove_at(item1)
	chance.remove_at(item1)
	
	var item2 = _pickItem(chance)
	shop_item2._set_stats(items[item2], cost[item2])
	items.remove_at(item2)
	cost.remove_at(item2)
	chance.remove_at(item2)
	
	var item3 = _pickItem(chance)
	shop_item3._set_stats(items[item3], cost[item3])
	items.remove_at(item3)
	cost.remove_at(item3)
	chance.remove_at(item3)
	
	shop_item1.connect("decreaseMoney", buy_item)
	shop_item2.connect("decreaseMoney", buy_item)
	shop_item3.connect("decreaseMoney", buy_item)

func buy_item(itemName, cost):
	if((cash - cost) >= 0):
		cash -= cost
		var newItem = Label.new()
		newItem.text = itemName
		$ItemContainer.add_child(newItem)
	else:
		print("Get your money up, not your funny up!")
		

func _pickItem(chance: Array):
	var itemPicked = false
	var item
	while itemPicked == false:
		item = randi_range(0,chance.size()-1)
		if chance[item] < (randi_range(2,5)):
			itemPicked = true
			return item


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cash_label = $Cash
	cash_label.text = "$" + str(cash)
	pass
