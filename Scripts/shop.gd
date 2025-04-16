extends Node2D

@export var cash : int
@export var num_shop_items = 4
var items : Array
var shop_items_arr : Array
var inventory : Array
@export var refresh_cost = 5
@export var inventory_size = 10
var exclude_items : Array
var inventory_names : Array
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	
	# Dictionaries right here are used to keep track of what each item does, its cost, and other important info
	
	var balls_item = {"Name": "Balls", "Cost": 2, "Chance": 1, "Description": "A pair of firm balls", "id": 0}
	var peenor_item = {"Name": "Peenor", "Cost": 1, "Chance": 1, "Description": "A firm shaft", "id": 1}
	var brassknuckles_item = {"Name": "Brass Knuckles", "Cost": 25, "Chance": 2, "Description": "For punching things", "id": 2}
	var jockstrap_item = {"Name": "Jock Strap", "Cost": 6, "Chance": 4, "Description": "You'd look good in it", "id": 3}
	var bong_item = {"Name": "Bong", "Cost": 42, "Chance": 3, "Description": "Hell yea", "id": 4}
	var holyhandgrenade_item = {"Name": "Holy Hand Grenade", "Cost": 1000, "Chance": 4, "Description": "Go away baldy!", "id": 5}
	var gun_item = {"Name": "Gun", "Cost": 63, "Chance": 3, "Description": "Parry this!", "id": 6}
	var baseballbat_item = {"Name": "Baseball Bat", "Cost": 17, "Chance": 3, "Description": "Guh!", "id": 7}
	
	# Array of dictionaries to keep them all in one spot
	
	items = [balls_item, peenor_item, brassknuckles_item, jockstrap_item, bong_item, holyhandgrenade_item, gun_item, baseballbat_item]
	# Creates an array of all of the items currently in the shop
	
	shop_items_arr = _create_shop()
	inventory = []
	inventory_names = []
	exclude_items = []
	$Button.text = "REFRESH $" + str(refresh_cost)
	
# Called when the buy button corresponding to an item is clicked. Signal emitted from shop_item.gd

func buy_item(id, shop_id):
	var item = items[id]
	var cost = item["Cost"]
	# Checks if you're a brokey
	
	if((cash - cost) >= 0):
		
		cash -= cost
		
		var new_item = Label.new()
		new_item.text = item["Name"]
		$ItemContainer.add_child(new_item)
		inventory.append(item)
		inventory_names.append(item["Name"])
		print("New Shop ID: " + str(shop_id))
		shop_items_arr[shop_id]._buy_object()
		# Adds the item to your "inventory"
		
		num_shop_items = min(num_shop_items, (items.size() - inventory_names.size()))
<<<<<<< Updated upstream
=======
		#print("Items array size: " + str(items.size()))
		#print("Inventory names array size: " + str(inventory_names.size()))
		#print("Num shop items: " + str(num_shop_items))
		#for i in inventory_names:
			#print("Name: " + i)
		#print(str(abs(items.size() - inventory_names.size())))
				
>>>>>>> Stashed changes
		
	else:
		
		# If you're a brokey, you gotta get your money up
		
		print("Get your money up, not your funny up!")
		
# Called during the _create_shop function. Stocks a specific item in shop based on its RNG and whether or not it is already in the shop

func _stock_item():
	var index # The index of the item being returned
	var picked = false # The boolean which is set to true when an item is picked
	
	while !picked: # Continue to roll for an item until one is picked
		index = randi_range(0,items.size()-1)
		var item = items[index]
		
		if !exclude_items.has(item["Name"]) and item["Chance"] < (randi_range(2,5)):
			exclude_items.append(item["Name"])
			picked = true
			return(index)

# Called when refreshing shop or creating shop for the first time

func _create_shop():
	
	exclude_items.clear()
	exclude_items.append_array(inventory_names)
	# Create array and then resize it to num_shop_items
	
	shop_items_arr.resize(num_shop_items)
	
	# Fill array with empty ShopItems
	
	for i in range(num_shop_items):
		var new_shop_item = ShopItem.new()
		$VBoxContainer.add_child(new_shop_item)
		shop_items_arr[i] = new_shop_item
	
	# Stock shop with random items
	
	for i in range(num_shop_items):
		
		# Grab item information using the index of an item from _stock_item
		
		var item = items[_stock_item()]
		
		# Create an item from the shop_items_arr
		
		var new_shop_item = shop_items_arr[i]
		
		# Set stats of created item to stats of randomized item
		
		print("Shop id: " + str(i))
		new_shop_item._set_stats(item["Name"], item["Cost"], item["Description"], item["id"], i)
		
		# Connect emitter from shop_item.gd
		
		new_shop_item.connect("decreaseMoney", buy_item)
		
		# Build all nodes (label, button, etc.)
		
		new_shop_item._build_object(100, (i*50))
	return(shop_items_arr)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	
	# Sets cash equal to how much you have
	
	var cash_label = $Cash
	cash_label.text = "$" + str(cash)
	pass
	

# Called when refresh button is pressed

func _on_button_pressed() -> void:
	# Reid, I would like you to work with me to make the refresh button increase in cost every time it is clicked
	if((cash - refresh_cost) >= 0):
		cash -= refresh_cost
		
		refresh_cost += 1
		$Button.text = "REFRESH $" + str(refresh_cost)
		
		for i in shop_items_arr:
			i.queue_free()
		shop_items_arr = _create_shop()
	else: print("these aint no broke boy cookies :(")


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
