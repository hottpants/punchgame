extends Node2D

@export var cash : int
@export var num_shop_items = 4
var items : Array
var shop_items_arr : Array
@export var refresh_cost = 5
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	
	# Dictionaries right here are used to keep track of what each item does, its cost, and other important info
	
	var balls_item = {"Name": "Balls", "Cost": 2, "Chance": 1, "Description": "A pair of firm balls", "id": 0}
	var peenor_item = {"Name": "Peenor", "Cost": 1, "Chance": 1, "Description": "A firm shaft", "id": 1}
	var brassknuckles_item = {"Name": "Brass Knuckles", "Cost": 25, "Chance": 2, "Description": "For punching things", "id": 2}
	var jockstrap_item = {"Name": "Jock Strap", "Cost": 6, "Chance": 4, "Description": "You'd look good in it", "id": 3}
	var bong_item = {"Name": "Bong", "Cost": 42, "Chance": 3, "Description": "Hell yea", "id": 4}
	var holyhandgrenade_item = {"Name": "Holy Hand Grenade", "Cost": 1000, "Chance": 4, "Description": "Total annihilation", "id": 5}
	var gun_item = {"Name": "Gun", "Cost": 63, "Chance": 3, "Description": "Parry this!", "id": 6}
	var baseballbat_item = {"Name": "Baseball Bat", "Cost": 17, "Chance": 3, "Description": "Guh!", "id": 7}
	
	# Array of dictionaries to keep them all in one spot
	
	items = [balls_item, peenor_item, brassknuckles_item, jockstrap_item, bong_item, holyhandgrenade_item, gun_item, baseballbat_item]
	
	# Creates an array of all of the items currently in the shop
	
	shop_items_arr = _create_shop(num_shop_items, items)
	$Button.text = "REFRESH $" + str(refresh_cost)
	
# Called when the buy button corresponding to an item is clicked. Signal emitted from shop_item.gd

func buy_item(itemName, cost):
	
	# Checks if you're a brokey
	
	if((cash - cost) >= 0):
		
		# Adds the item to your "inventory"
		
		cash -= cost
		var newItem = Label.new()
		newItem.text = itemName
		$ItemContainer.add_child(newItem)
	else:
		
		# If you're a brokey, you gotta get your money up
		
		print("Get your money up, not your funny up!")
		
# Called during the _create_shop function. Stocks a specific item in shop based on its RNG and whether or not it is already in the shop

func _stock_item(chance: Array, shop_items: Array):
	var itemPicked = false
	var index
	
	# Using a counter to determine when all items in shop have been checked in order to prevent duplicates
	
	var count = 0
	
	# While loop to continue attempting to stock item if one of its type is already in there, or if the roll for RNG fails
	
	while itemPicked == false:
		
		# Roll for random item
		
		index = randi_range(0,chance.size()-1)
		
		# Roll and check for RNG
		
		if chance[index]["Chance"] < (randi_range(2,5)):
			
			# Iterate through each item and increment counter
			
			for i in shop_items:
				
				# If item originally rolled matches an item in the shop, do not increment counter
				
				if chance[index]["Name"] == i._get_name():
					pass
					
				# If item originally rolled does not match an item in the shop, increment counter
					
				else: count += 1
			
			# Check to see if number of objects not matching is equal to total objects in shop
			
			if count == shop_items.size():
				itemPicked = true
				return index
				
			# If number of objects not matching is NOT equal to total objects in shop, then item type is already in shop. Reset counter and try again
				
			else: count = 0

# Called when refreshing shop or creating shop for the first time

func _create_shop(num_shop_items: int, items: Array):
	
	# Create array and then resize it to num_shop_items
	
	var shop_items_arr = []
	shop_items_arr.resize(num_shop_items)
	
	# Fill array with empty ShopItems
	
	for i in range(num_shop_items):
		var new_shop_item = ShopItem.new()
		$VBoxContainer.add_child(new_shop_item)
		shop_items_arr[i] = new_shop_item
	
	# Stock shop with random items
	
	for i in range(num_shop_items):
		
		# Grab item information using the index of an item from _stock_item
		
		var item = items[_stock_item(items, shop_items_arr)]
		
		# Create an item from the shop_items_arr
		
		var new_shop_item = shop_items_arr[i]
		
		# Set stats of created item to stats of randomized item
		
		new_shop_item._set_stats(item["Name"], item["Cost"], item["Description"])
		
		# Connect emitter from shop_item.gd
		
		new_shop_item.connect("decreaseMoney", buy_item)
		
		# Build all nodes (label, button, etc.)
		
		new_shop_item._build_object(100, (i*50))
	return(shop_items_arr)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	
	# Sets cash equal to how much you have
	
	var cash_label = $Cash
	cash_label.text = "$" + str(cash)
	pass

# Called when refresh button is pressed

func _on_button_pressed() -> void:
	if cash - refresh_cost >= 0:
		cash -= refresh_cost
		
		refresh_cost += 1
		$Button.text = "REFRESH $" + str(refresh_cost)
		
		for i in shop_items_arr:
			i.queue_free()
		shop_items_arr = _create_shop(num_shop_items, items)
	else: print("these aint no broke boy cookies :(")
	
