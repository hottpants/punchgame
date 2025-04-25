extends Node2D

## INVENTORY VARS

var inventory : Array
var inventory_size = 10
var inventory_names : Array

## SHOP VARS

var items : Array
var shop_items_arr : Array
var num_shop_items = 4
var refresh_cost = 5
var exclude_items : Array

## PLAYER VARS

var player
@export var cash : int

## SCENE VARS

@onready var item_scene = load("res://Scenes/Item.tscn")
var inventory_manager


func _ready() -> void:
	player = $"../Player"
	
	# Dictionaries right here are used to keep track of what each item does, its cost, and other important info
	
	var balls_item = {"Name": "Balls", "Cost": 2, "Chance": 1, "Description": "A pair of firm balls", "id": 0}
	var peenor_item = {"Name": "Peenor", "Cost": 1, "Chance": 1, "Description": "A firm shaft", "id": 1}
	var brassknuckles_item = {"Name": "Brass Knuckles", "Cost": 25, "Chance": 2, "Description": "For punching things", "id": 2}
	var jockstrap_item = {"Name": "Jock Strap", "Cost": 6, "Chance": 4, "Description": "You'd look good in it", "id": 3}
	var bong_item = {"Name": "Bong", "Cost": 42, "Chance": 3, "Description": "Hell yea", "id": 4}
	var holyhandgrenade_item = {"Name": "Holy Hand Grenade", "Cost": 1000, "Chance": 4, "Description": "Go away baldy!", "id": 5}
	var gun_item = {"Name": "Gun", "Cost": 63, "Chance": 3, "Description": "Parry this!", "id": 6}
	var baseballbat_item = {"Name": "Baseball Bat", "Cost": 17, "Chance": 3, "Description": "Guh!", "id": 7}
	var tophat_item = {"Name": "Top Hat", "Cost": 60, "Chance": 3, "Description": "For capitalist pigs", "id": 8}
	var knife_item = {"Name": "Knife", "Cost": 14, "Chance": 2, "Description": "Like a tiny little sword", "id": 9}
	var rolex_item = {"Name": "Rolex", "Cost": 100, "Chance": 2, "Description": "Get your money up not your funny up", "id": 10}
	var steroids_item = {"Name": "Steroids", "Cost": 38, "Chance": 1, "Description": "Shrinks yer balls", "id": 11}
	var chewinggum_item = {"Name": "Chewing Gum", "Cost": 15, "Chance": 1, "Description": "Lock in.", "id": 12}
	var worminfestedfruit_item = {"Name": "Worm-Infested Fruit", "Cost": 10, "Chance": 1, "Description": "Reeks of poison", "id": 13}
	var worminfestedflesh_item = {"Name": "Worm-Infested Flesh", "Cost": 75, "Chance": 2, "Description": "Reeks of rot", "id": 14}
	var worminfestedore_item = {"Name": "Worm-Infested Ore", "Cost": 190, "Chance": 3, "Description": "Reeks of uneasieness", "id": 15}
	var worminfestedrelic_item = {"Name": "Worm-Infested Relic", "Cost": 450, "Chance": 4, "Description": "Reeks of disaster", "id": 16}
	var crowbar_item = {"Name": "Crowbar", "Cost": 20, "Chance": 1, "Description": "What is this? A half life too?", "id": 17}
	var fryingpan_item = {"Name": "Frying Pan", "Cost": 30, "Chance": 2, "Description": "Used by amateurs", "id": 18}
	var goldfryingpan_item = {"Name": "Golden Frying Pan", "Cost": 120, "Chance": 4, "Description": "Used by professionals", "id": 19}
	var fjhotsauce_item = {"Name": "Freaky John's Hot Sauce", "Cost": 50, "Chance": 2, "Description": "Freaky John thought his juice might come in handy!", "id": 20}
	var fjsweatysockslingshot_item = {"Name": "Freaky John's Sweaty Sock Slingshot", "Cost": 12, "Chance": 1, "Description": "Freaky John's favorite way to clear a room!", "id": 21}
	var fjunpickledcucumberjar_item = {"Name": "Freaky John's Unpickled Cucumber Jar", "Cost": 70, "Chance": 2, "Description": "Crunchy and tastes nothing like cucumber!", "id": 22}
	var fjputridpicklejar_item = {"Name": "Freaky John's Putrid Pickle Jar", "Cost": 140, "Chance": 3, "Description": "Freaky John's favorite mid-morning snack", "id": 23}
	var fjcalamitycube_item = {"Name": "Freaky John's Calamity Cube", "Cost": 190, "Chance": 4, "Description": "Even Freaky John can't solve this thing!", "id": 24}
	var thecommunistmanifesto_item = {"Name": "The Communist Manifesto", "Cost": 15, "Chance": 4, "Description": "Karl Marx would be proud!", "id": 24}
	#var _item = {"Name": "", "Cost": , "Chance": , "Description": "", "id": }
	
	# Array of dictionaries to keep them all in one spot
	
	items = [balls_item, peenor_item, brassknuckles_item, jockstrap_item, bong_item, holyhandgrenade_item, gun_item, 
	baseballbat_item, tophat_item, knife_item, rolex_item, steroids_item, chewinggum_item, worminfestedfruit_item, 
	worminfestedflesh_item, worminfestedore_item, worminfestedrelic_item, crowbar_item, fryingpan_item, goldfryingpan_item, 
	fjhotsauce_item, fjsweatysockslingshot_item, fjunpickledcucumberjar_item, fjputridpicklejar_item, fjcalamitycube_item,
	thecommunistmanifesto_item]
	
	# Creates an instance of inventory.tscn
	
	inventory_manager = load("res://Scenes/Inventory.tscn").instantiate()
	
	# Add inventory_manager to the node tree as a child of Shop/ColorRect
	
	$ColorRect.add_child(inventory_manager)
	
	# Set the inventory of inventory_manager to the player's inventory
	
	inventory_manager.set_inventory(player.get_inventory())
	
	inventory_manager.item_sold.connect(reset_inventory)
	
	# Set shop inventory to player inventory
	
	inventory = player.get_inventory()
	
	# Add all inventory item names to inventory_names array
	
	for i in inventory: inventory_names.append(i["Name"])
	
	# Set number of shop items equal to the smaller number between the current number of shop items and the items remaining in the item pool
	
	num_shop_items = min(num_shop_items, (items.size() - inventory_names.size()))
	
	# Create a new shop and set shop_items_arr equal to the items created
	
	shop_items_arr = create_shop()
	
	# Set refresh button text to current cost of refresh
	
	$ColorRect/Button.text = "REFRESH $" + str(refresh_cost)
	
	# Set current cash shown in shop equal to cash stored in player
	
	cash = player.get_cash()
	
	# Sets cash label text equal to the cash the player has
	
	$ColorRect/Cash.text = "$" + str(cash)

# Called when the buy button corresponding to an item is clicked. Signal emitted from shop_item.gd
func buy_item(id, shop_id):
	
	# Sets item to the item in items using the index of id
	
	var item = items[id]
	
	# Sets cost equal to the item's cost
	
	var cost = item["Cost"]
	
	if (cash - cost) >= 0: # Checks if you're a brokey
		
		# Removes the cost of the item the player attempts to buy from their total cash
		
		cash -= cost
		
		# Sets cash label text equal to the cash the player has
		
		$ColorRect/Cash.text = "$" + str(cash)
		
		# Adds item to inventory.gd
		
		inventory_manager.add_item(item)
		
		# Adds item to inventory
		
		inventory.append(item)
		
		# Adds item name to inventory_names
		
		inventory_names.append(item["Name"])
		
		# Mark item as bought buy calling the _buy_object() function
		
		shop_items_arr[shop_id].buy_item()
		
		# Set number of shop items equal to the smaller number between the current number of shop items and the items remaining in the item pool
		
		num_shop_items = min(num_shop_items, (items.size() - inventory_names.size()))
		
	else:
		
		# If you're a brokey, you gotta get your money up
		
		print("Get your money up, not your funny up!")

# Called during the create_shop function. Stocks a specific item in shop based on its RNG and whether or not it is already in the shop or inventory
func _stock_item():
	var index # The index of the item being returned
	var picked = false # The boolean which is set to true when an item is picked
	
	while !picked: # Continue to roll for an item until one is picked
		
		# Roll for random item
		
		index = randi_range(0,items.size()-1)
		
		# Set item equal to the index of the item rolled
		
		var item = items[index]
		
		# If the item rolled doesn't already exists in exclude_items AND the item's chance is successfully rolled, put it in the shop
		
		if !exclude_items.has(item["Name"]) and item["Chance"] < (randi_range(2,5)):
			
			# Add the item that was successfully rolled into the exclude_items list to make sure it does not get added to the shop again
			
			exclude_items.append(item["Name"])
			
			# Mark picked as true and return the index of the item rolled
			
			picked = true
			return(index)

# Called when refreshing shop or creating shop for the first time
func create_shop():
	
	# Sets cash label text equal to the cash the player has
	
	$ColorRect/Cash.text = "$" + str(cash)
	
	# Clears the list of excluded items since if a new shop is being rolled, new items would also need to be rolled
	
	exclude_items.clear()
	
	# Add the array of inventory items to the array of excluded items so that items in the inventory cannot be rolled in the shop
	
	exclude_items.append_array(inventory_names)
	
	# Resize the shop_items_arr to num_shop_items
	
	shop_items_arr.resize(num_shop_items)
	
	# Fills array with empty ShopItems
	
	for i in range(num_shop_items):
		
		# Creates instance of Item.tscn
		
		var new_shop_item = item_scene.instantiate()
		
		# Adds new_shop_item to node tree as a child of Shop/ColorRect/VBoxContainer
		
		$ColorRect/VBoxContainer.add_child(new_shop_item)
		
		# Adds new_shop_item to shop_items_arr
		
		shop_items_arr[i] = new_shop_item
	
	# Stock shop with random items
	
	for i in range(num_shop_items):
		
		# Grab item information using the index of an item from _stock_item in the array items
		
		var item = items[_stock_item()]
		
		# Create an item from the shop_items_arr
		
		var new_shop_item = shop_items_arr[i]
		
		# Set stats of created item to stats of randomized item
		
		new_shop_item._set_stats(item["Name"], item["Cost"], item["Description"], item["id"], i)
		
		# Connect emitter from shop_item.gd
		
		new_shop_item.connect("decrease_money", buy_item)
		
		# Build items
		
		new_shop_item.build_item(i*50)
	return(shop_items_arr)

func _process(_delta: float) -> void:
	pass

# Called when refresh button is pressed
func _on_button_pressed() -> void:
	
	# Checks for if you have enough money to buy a refresh
	
	if (cash - refresh_cost) >= 0:
		
		# Substracts refresh cost from total cash
		
		cash -= refresh_cost
		
		# Increase refresh cost after use
		
		refresh_cost += 1
		
		# Update refresh button text to new cost
		
		$ColorRect/Button.text = "REFRESH $" + str(refresh_cost)
		
		# Kill all items in shop
		
		for i in shop_items_arr:
			i.queue_free()
		
		# Create new shop
		
		shop_items_arr = create_shop()
		
	else: print("these aint no broke boy cookies :(")

# Called when continue button is pressed. Continues game
func _on_continue_button_pressed() -> void:
	
	for i in inventory: print("Inventory: " + i["Name"])
	print("-----------")
	
	# Update player's cash
	
	player.set_cash(cash)
	
	# Update player's inventory
	
	player.set_inventory(inventory)
	
	# References GameCanvas and calls the reset function
	
	$"../../".reset()
	
	# Closes the shop
	
	self.queue_free()

func reset_inventory(_item_list):
	inventory = _item_list
	exclude_items = _item_list
	print("BALLS: " + str(_item_list))
	
	
