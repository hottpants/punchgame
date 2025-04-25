extends CharacterBody3D

class_name Enemy

## ATTACK VARS

var attack_choice : int # Attack choice of current attack which is only set after attack starts
var rand_attack_choice : int # Attack choice of current attack. Is set to a random value
var attack_is_active : bool # Determines whether or not the attack detection is active
var attack_finished : bool # Determines whether or not the attack is moving or stopped

## HEALTH VARS

var health : float # Health of enemy
var enemy_max_health : int # Max health of current enemy
var alive : bool # Determines whether or not the enemy is alive

## DROP VARS

var loot : int # Amount of money dropped from enemy

## SCENE VARS

@onready var end_of_round = load("res://Scenes/end_of_round.tscn") # end_of_round scene. Preloaded for optimization
@onready var health_bar_scene = load("res://Scenes/health_bar.tscn") # health_bar scene. Preloaded for optimization
@onready var damage_scene = load("res://Scenes/damage.tscn") # damage scene. Preloaded for optimization

var enemy_health_bar # Uses an instance of health_bar.tscn
var damage_number # Uses an instance of damage.tscn


# When enemy health is 0 this is called through a signal connected from health_bar.gd
func die():
	alive = false
	
	# Randomize money drops between 5-25 (before multiplier)
	
	loot = randi_range(5,25)
	
	# Creates a new window using the scene end_of_round and adds it to node tree
	
	var new_pop_up = end_of_round.instantiate()
	$"../".add_child(new_pop_up)
	
	# Set location to center of screen
	
	new_pop_up.set_position(Vector2(575.872, 324.0)-new_pop_up.size/2)
	
	# Call the on_win function to prep the information on the pop up window
	
	new_pop_up.on_win(loot, $"../Player"._get_stage())

# Resets all data for enemy
func reset():
	spawn_health_bar()
	set_attack()
	enemy_max_health = 100#pow(100, $"../Player"._get_stage()) # Placeholder. Going to be equal to whatever health value is given from specific enemy from enemy table
	
	# Calls function init_health from enemy_health_bar and sets max health to enemy_max_health
	
	enemy_health_bar.init_health(enemy_max_health)
	alive = true # Enemy is alive now, allows all enemy functionality to continue

# Spawns health bar. Loads it from the health_bar scene
func spawn_health_bar():
	
	# Creates an instance of health_bar.tcsn
	
	enemy_health_bar = health_bar_scene.instantiate()
	
	# Adds the instance to the viewport under Enemy
	
	$HealthBarViewport.add_child(enemy_health_bar)
	
	# Sets location and size to fit viewport
	
	enemy_health_bar.set_position(Vector2(0,0))
	enemy_health_bar.set_size(Vector2(360,20))
	
	# Connects signal health_zero from health_bar.gd to the function die(). health_zero is emitted when health_bar.value <= 0
	
	enemy_health_bar.health_zero.connect(die)

func _ready() -> void:
	reset()

# Damages enemy. Is called from the player.gd (as of right now)
func damage_enemy(damage: float):
	if alive: # No damage can be done if the enemy is dead
		
		# Sets enemy.health = enemy_health_bar.health
		# enemy.health only gets changed here and is otherwise used as a placeholder for enemy_health_bar.health
		
		health = enemy_health_bar.health
		
		# Sets new health of enemy_health_bar equal to current health minus the damage dealt to the enemy by player
		
		enemy_health_bar._set_health(health - damage)
		
		# Creates a new damage.tscn instance. These are the damage numbers that appear when you hit the enemy
		
		damage_number = damage_scene.instantiate()
		
		# Adds damage_number to the node tree as a sibling of Enemy
		
		add_sibling(damage_number)
		
		# Sets the text on the damage number equal to the amount of damage received by the enemy
		
		damage_number.set_damage(damage)

# Resets location of attacks
func reset_attack_location():
	$Attack.position.z = 0
	$Attack.rotation.y = deg_to_rad(0)
	$Attack.rotation.x = deg_to_rad(0)

# Sets up which attack is about to be thrown. This is how the player will be able to determine which way to dodge
func set_attack():
	
	# Reset attack_choice
	
	attack_choice = 0
	
	# Deactive detection for if player is hit and also make sure attack is marked as having started
	
	attack_is_active = false
	attack_finished = false
	
	reset_attack_location()
	
	# Set the attack choice to one of three choices
	
	rand_attack_choice = randi_range(1,3)
	
	# Set location/rotation of attack to starting position of each type of attack
	
	match rand_attack_choice:
		1: # Wide swing from players left
			$Attack.rotation.y = deg_to_rad(-25) 
		2: # Swing from above player down
			$Attack.rotation.x = deg_to_rad(-25)
		3: # Center Jab
			$Attack.position.z = -3
	
	# Start timer to count down attack
	$AttackTimer.start()

# Rotates an attack on an axis. With more attacks, this function might get more complicated
func do_attack_rotation(delta, axis : String):
	match axis:
		"x": # From top to bottom
			if $Attack.rotation.x < deg_to_rad(-5): # Checks if attack has reached final location. If it hasn't, continue to move it
				$Attack.rotation.x += 4 * delta
			else: # If attack has reached final location, then mark attack as finished and deactivate hit detection for attack
				attack_finished = true 
				attack_is_active = false
		"y": # From left to right
			if $Attack.rotation.y < deg_to_rad(-5): # Checks if attack has reached final location. If it hasn't, continue to move it
				$Attack.rotation.y += 4 * delta
			else: # If attack has reached final location, then mark attack as finished and deactivate hit detection for attack
				attack_finished = true
				attack_is_active = false
		"z": # Might not ever get used as its from enemy's close right to enemy's close left
			$Attack.rotation.z += 4 * delta

# Translates an attack
func do_attack_transform(delta, attack : String):
	match attack:
		"jab": # From center of enemy to center of player
			if $Attack.position.z < -0.5: # Checks if attack has reached final location. If it hasn't, continue to move it
				$Attack.position.z += 32 * delta
			else: # If attack has reached final location, then mark attack as finished and deactivate hit detection for attack
				attack_finished = true
				attack_is_active = false

func _process(_delta: float) -> void:
	if alive:
		
		# Make text showing when next attack will happen count down
		
		$AttackTiming.text = str("%.2f" % $AttackTimer.get_time_left())
		
		if attack_finished and $AttackTimer.is_stopped(): # Once attack is finished AND the attack timer is inactive, set new attack
			set_attack()

func _physics_process(delta: float) -> void:
	if alive:
		match attack_choice: # Calls the attack functions here
			0:
				pass
			1: # Attack from left to right
				do_attack_rotation(delta, "y")
			2: # Attack from up to down
				do_attack_rotation(delta, "x")
			3: # Attack from center of enemy to center of player
				do_attack_transform(delta, "jab")

# Checks for collision between enemy attack and player
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == $"../Player" and attack_is_active: # If the body entered is the player and the attack is currently active, make player lose health
		print("HIT")
		$"../Player"._lose_health(1)

# Timer for attacks. Every time it times out, a new attack happens. Only restarts once current attack is finished moving
func _on_attack_timer_timeout() -> void:
	
	# Stops timer because otherwise it automatically restarts
	
	$AttackTimer.stop()
	if alive:
		
		# Mark attack as not finished and attack as active. Then set attack_choice equal to rand_attack_choice
		
		attack_is_active = true
		attack_finished = false
		attack_choice = rand_attack_choice



## for i in range(5):
## 	var bob = load(Bob).instantiate()
## 	add_child(bob)
## 	bob.change(i*5)
