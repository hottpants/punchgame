extends Node2D

@export var cash : int

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var num_shop_items = 4
	
	var balls_item = {"Name": "Balls", "Cost": 2, "Chance": 1, "Description": "A pair of firm balls", "Location": 0, "id": 0}
	var peenor_item = {"Name": "Peenor", "Cost": 1, "Chance": 1, "Description": "A firm shaft", "Location": 0, "id": 1}
	var brassknuckles_item = {"Name": "Brass Knuckles", "Cost": 25, "Chance": 2, "Description": "For punching things", "Location": 0, "id": 2}
	var jockstrap_item = {"Name": "Jock Strap", "Cost": 6, "Chance": 4, "Description": "You'd look good in it", "Location": 0, "id": 3}
	var bong_item = {"Name": "Bong", "Cost": 42, "Chance": 3, "Description": "Hell yea", "Location": 0, "id": 4}
	var holyhandgrenade_item = {"Name": "Holy Hand Grenade", "Cost": 1000, "Chance": 4, "Description": "Total annihilation", "Location": 0, "id": 5}
	var gun_item = {"Name": "Gun", "Cost": 63, "Chance": 3, "Description": "Parry this!", "Location": 0, "id": 6}
	var baseballbat_item = {"Name": "Baseball Bat", "Cost": 17, "Chance": 3, "Description": "Guh!", "Location": 0, "id": 7}
	
	var items = [balls_item, peenor_item, brassknuckles_item, jockstrap_item, bong_item, holyhandgrenade_item, gun_item, baseballbat_item]
	
	var shop_items_arr = [_create_shop(num_shop_items, items)]
	print(shop_items_arr[0])
	for i in range(shop_items_arr.size()-1):
		print(shop_items_arr[i]["Name"])
		shop_items_arr[i]._build_object()
	
func buy_item(itemName, cost):
	if((cash - cost) >= 0):
		cash -= cost
		var newItem = Label.new()
		newItem.text = itemName
		$ItemContainer.add_child(newItem)
	else:
		print("Get your money up, not your funny up!")
		

func _stock_item(chance: Array, shop_items: Array):
	var itemPicked = false
	var index
	var count = 0
	
	while itemPicked == false:
		index = randi_range(0,chance.size()-1)
		
		if chance[index]["Chance"] < (randi_range(2,5)):
			for i in shop_items:
				if chance[index]["Name"] == i._get_name():
					print(chance[index]["Name"])
					print(i._get_name())
				else: count += 1
					
			if count == shop_items.size():
				print(chance[index]["Name"])
				itemPicked = true
				return index
			else: count = 0
	
func _create_shop(num_shop_items: int, items: Array):
		var shop_items_arr = []
		shop_items_arr.resize(num_shop_items)
		for i in range(num_shop_items):
			var new_shop_item = ShopItem.new()
			$VBoxContainer.add_child(new_shop_item)
			shop_items_arr[i] = new_shop_item
		for i in range(num_shop_items):
			var item = items[_stock_item(items, shop_items_arr)]
			var new_shop_item = shop_items_arr[i]
			new_shop_item._set_stats(item["Name"], item["Cost"], item["Description"])
			new_shop_item.connect("decreaseMoney", buy_item)
			
			new_shop_item._build_object(100, (i*50))
		return(shop_items_arr)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cash_label = $Cash
	cash_label.text = "$" + str(cash)
	pass
	
