extends Node2D

@export var cash : int

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var shop_item1 = $VBoxContainer/Item
	var shop_item2 = $VBoxContainer/Item2
	
	shop_item1._set_stats("balls", 10)
	shop_item2._set_stats("Peenor", 4)
	$VBoxContainer/Item.connect("decreaseMoney", buy_item)
	$VBoxContainer/Item2.connect("decreaseMoney", buy_item)

func buy_item(itemName, cost):
	if((cash - cost) >= 0):
		cash -= cost
		var newItem = Label.new()
		newItem.text = itemName
		$ItemContainer.add_child(newItem)
	else:
		print("Get your money up, not your funny up!")
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cash_label = $Cash
	cash_label.text = "$" + str(cash)
	pass
