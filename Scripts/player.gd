extends CharacterBody3D

## DAMAGE VARS

var light_damage := 5 # Light attack damage
var heavy_damage := 15 # Heavy attack damage
var light_multiplier := 1.0 # Light attack damage multiplier
var heavy_multiplier := 1.0 # Heavy attack damage multiplier

## BASE STAT VARS

var health := 3 # Health
var stage := 1 # Stage - Determines amount of money received from winning, item drops, chances for higher enemies and rarer items in shop
var cash := 0 # Cash
var player_inventory : Array # Inventory of the player. Stores Dictionaries which contain item data
var inventory_size := 6 # Size of the inventory (Currently not implemented)

## MOVEMENT VARS

var rotate_state := 0 # Determines current location/status of the player dodge action
var vel := 8.0 # Speed of dodge
var max_rotation := 45 # Maximum range of dodge (in degrees)

## FOCUS VARS

var focus_drain := 1.0 # Amount of focus drained per frame from dodging
var focus_recovery := 2.0 # Amount of focus regained while standing still
var focus_dodge_min := 25.0 # Focus required to start a dodge
var focus_light_min := 4 # Focus required to do a light attack
var focus_heavy_min := 35 # Focus required to do a heavy attack

## MISC VARS

var dodge_chance := 0.0 # Chance to dodge an attack
var heal_on_punch_chance := 0.0 # Chance to heal on doing an attack
var fp_drain_reduction := 1.0 # Multiplier reducing focus drain

## SCENE VARS

@onready var shop_scene = load("res://Scenes/shop.tscn") # shop.tscn


func _ready() -> void:
	pass

# Rest player (just calls check_items for now)
func reset():
	check_items()

# Increase stage upon winning a round
func increase_stage():
	
	# Create instance of shop.tscn
	
	var new_shop = shop_scene.instantiate()
	
	# Add new_shop to node tree as child of Node3D
	
	$"../".add_child(new_shop)
	
	# Increment stage by 1 (will make it more variable in the future)
	
	stage += 1

# Checks to see what items player has in inventory in order to give them functionality
func check_items():
	
	# Reset all multipliers and chances to default values before summing them. This makes sure that if you sell an item it does not keep its effect
	# Also makes sure that items don't add their multipliers multiple times
	
	light_multiplier = 1
	heavy_multiplier = 1
	dodge_chance = 0.0
	heal_on_punch_chance = 0.0
	fp_drain_reduction = 1.0
	
	# Checks ids of each item in inventory
	
	for item in player_inventory:
		match item["id"]:
			0: # Balls
				dodge_chance += 0.05
			1: # Peenor
				heal_on_punch_chance += 0.05
			2: # Brass knuckles
				light_multiplier += 0.5
				heavy_multiplier += 0.5
			3: # Jock strap
				fp_drain_reduction -= 0.50
			4: # Bong
				pass
			5: # Holy hand grenade
				heavy_multiplier += 4
				light_multiplier += 4
			6: # Gun
				heavy_multiplier += 2
			7: # Baseball bat
				pass
			8: # Top hat
				light_multiplier += float(cash)/100
				heavy_multiplier += float(cash)/100
			_:
				return

# Sets player inventory equal to inventory received from shop after purchasing items
func set_inventory(new_inventory : Array):
	player_inventory = new_inventory

# Returns player inventory. Called in shop in order to manage the items in it when buying/selling
func get_inventory():
	return(player_inventory)

# Returns current stage
func _get_stage():
	return stage

# Increases cash based on the amount passed when function is called
func pay(amount : int):
	cash += amount

# Set cash equal to the amount passed when function is called
func set_cash(amount : int):
	cash = amount

# Returns cash
func get_cash():
	return cash


func _physics_process(delta: float) -> void:
	
	## KEY FOR rotate_state: 
	## rotate_state 0: Not moving
	## rotate_state 1: Rotating to the left; rotate_state 2: Rotating from left to right after releasing input
	## rotate_state 3: Rotating to the right; rotate_state 4: Rotating from right to left after releasing input
	
	# Checks for if the input is pressed. If it is AND the player is rotating left AND the player has enough focus THEN set velocity and rotate state
	
	if Input.is_action_pressed("dodge_left") and rotate_state < 3 and $FocusMeter.value > focus_dodge_min:
		vel = 5
		rotate_state = 1
	
	# If dodge_left is not being pressed but instead dodge_right is, check to see if the player is rotating right or standing still AND has enough focus 
	# THEN set velocity and rotate state
	
	elif Input.is_action_pressed("dodge_right") and (rotate_state > 2 or rotate_state == 0) and $FocusMeter.value > focus_dodge_min:
		vel = -5
		rotate_state = 3
	
	# If dodge_left has been released or the player has run out of focus AND the player's rotation is less than 0 THEN set velocity and rotate state
	
	if (Input.is_action_just_released("dodge_left") or $FocusMeter.value <= 1) and rotation.y < 0:
		vel = 5
		rotate_state = 2
	
	# If dodge_right has been released or the player has run out of focus AND the player's rotation is greater than 0 THEN set velocity and rotate state
	
	if (Input.is_action_just_released("dodge_right") or $FocusMeter.value <= 1) and rotation.y > 0:
		vel = -5
		rotate_state = 4
	
	# If rotating back from left or right AND rotation is between -5 and 5 THEN set rotate state to 0
	
	if (rotate_state == 2 or rotate_state == 4) and (rad_to_deg(rotation.y) < 5 and rad_to_deg(rotation.y) > -5):
		rotate_state = 0
	
	# If attack_light has been just pressed AND player is not rotating AND has more focus than focus required for a light attack then do a light attack
	
	if Input.is_action_just_pressed("attack_light") and rotate_state == 0 and $FocusMeter.get_value() > focus_light_min:
		
		# Decrease focus meter
		
		$FocusMeter.value = $FocusMeter.value - (5 * focus_light_min * fp_drain_reduction)
		
		# Damage enemy
		
		$"../Enemy".damage_enemy(light_damage * light_multiplier)
		
		# Check for heal on punch
		
		heal_on_punch()
	
	# If attack_heavy has been just pressed AND player is not rotating AND has more focus than focus required for a heavy attack then do a heavy attack
	
	if Input.is_action_just_pressed("attack_heavy") and rotate_state == 0 and $FocusMeter.get_value() > focus_heavy_min:
		
		# Decrease the focus meter
		
		$FocusMeter.value = $FocusMeter.value - (focus_heavy_min * fp_drain_reduction)
		
		# Damage enemy
		
		$"../Enemy".damage_enemy(heavy_damage * heavy_multiplier)
	
	# Used for debugging
	
	if Input.is_action_just_pressed("change_to_shop"):
		var new_shop = shop_scene.instantiate()
		$"../".add_child(new_shop)


func _process(delta: float) -> void:
	
	# Set hearts equal to total health
	
	match health:
		0: # 0 health / dead
			$Heart1.self_modulate.a = 0.1
		1: # 1 health
			$Heart1.self_modulate.a = 1.0
			$Heart2.self_modulate.a = 0.1
		2: # 2 health
			$Heart1.self_modulate.a = 1.0
			$Heart2.self_modulate.a = 1.0
			$Heart3.self_modulate.a = 0.1
		3: # 3 health / full health
			$Heart1.self_modulate.a = 1.0
			$Heart2.self_modulate.a = 1.0
			$Heart3.self_modulate.a = 1.0
	
	# Checks rotate_state in order to apply focus drain and rotate transform
	
	match rotate_state:
		0: # Sitting still - Recover focus and not moving
			rotation.y = 0
			$FocusMeter.value += focus_recovery
		1: # Rotating left - Drain focus and rotate left
			$FocusMeter.value -= focus_drain
			if rotation.y >= deg_to_rad(-1 * max_rotation):
				rotation.y -= vel * delta
		2: # Rotating to center from left - Recover focus slowly and rotate right
			if rotation.y < deg_to_rad(0):
				rotation.y += vel * delta
				$FocusMeter.value += focus_recovery/2
			else: rotate_state = 0
		3: # Rotating right - Drain focus and rotate right
			$FocusMeter.value -= focus_drain
			if rotation.y <= deg_to_rad(max_rotation):
				rotation.y -= vel * delta
		4: # Rotating to center from right - Recover focus slowly and rotate left
			if rotation.y > deg_to_rad(0):
				rotation.y += vel * delta
				$FocusMeter.value += focus_recovery/2
			else: rotate_state = 0

# Decreases health when hit by attack. Called in Enemy
func _lose_health(amount: int):
	
	# Roll for dodge chance
	
	var rand = randf_range(0.0, 1.0)
	if dodge_chance > rand:
		print("DODGED!")
	else:
		health -= amount

# Checks to see if the player's health is increased based on item chance rolls
func heal_on_punch():
	var rand = randf_range(0.0, 1.0)
	if heal_on_punch_chance > rand and health != 3:
		health += 1
		print("HEALED!")
