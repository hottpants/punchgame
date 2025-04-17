extends CharacterBody3D

class_name Enemy

var enemy_damage : float
var health_shake_state : int
var count : int
var attack_choice : int
var enemy_cd_state : int
var rand_attack_choice : int
var enemy_max_health : int
var alive : bool
var loot : int

@onready var timer = $HealthBarViewport/EnemyHealthBar/DamageTimer
@onready var damage_bar = $HealthBarViewport/EnemyHealthBar/DamageBar
@onready var pop_up_scene = load("res://Scenes/end_of_round.tscn")

var health = 0 : set = _set_health

func _set_health(new_health):
	if alive:
		var prev_health = health # prev = 100
		print("HEALTH: " + str(health))
		health = min($HealthBarViewport/EnemyHealthBar.max_value, new_health) # 100, 95 ->
		$HealthBarViewport/EnemyHealthBar.value = health # 95
		# health = 95
	
		if health <= 0:
			var new_pop_up = pop_up_scene.instantiate()
			alive = false
			$"../".add_child(new_pop_up)
			$HealthBarViewport/EnemyHealthBar.queue_free()
			
		if health < prev_health:
			timer.start()
				
		else:
			damage_bar.value = health

func init_health(_health):
		health = _health
		$HealthBarViewport/EnemyHealthBar.max_value = health
		$HealthBarViewport/EnemyHealthBar.value = health
		damage_bar.max_value = health
		damage_bar.value = health
		
func _on_damage_timer_timeout() -> void:
	damage_bar.value = health
	
func _ready() -> void:
	loot = ($"../Player"._get_stage()) * randi_range(5,25)
	print("Payout: " + str(loot) + " Stage: " + str($"../Player"._get_stage()))
	
	alive = true
	enemy_max_health = 100 # Temporary
	$Attack.rotation.x = deg_to_rad(-25)
	enemy_damage = 10
	health_shake_state = 3
	init_health(enemy_max_health)
	count = 0
	$Timer.start()
	_shake_healthbar(0)
	
func _damage_enemy(damage: float):
	_set_health(health - damage)
	print("Health: " + str(health))
	health_shake_state = 0
	$HealthBarTimer.start()
	

func _enemy_attack():
	$EnemyCDTimer.start()
	
func _on_timer_timeout() -> void:
	print("Attack: " + str(rand_attack_choice))
	attack_choice = rand_attack_choice
	_enemy_attack()
	$Timer.start()

func _shake_healthbar(angle):
	$EnemyHealthSprite.rotation.z = lerp_angle(rotation.z, deg_to_rad(angle), 0.1)

func _rotate_attack(angle : int, axis : String):
	match axis:
		"x":
			
			# https://www.youtube.com/watch?v=uIU0NfO_tgQ USE THIS
			#print("Init Rotation X: " + str(rad_to_deg($Attack.rotation.x)))
			$Attack.rotation.x = lerp_angle($Attack.rotation.x, deg_to_rad(angle), 0.1)
			#print("Rotation X: " + str(rad_to_deg($Attack.rotation.x)))
		"y":
			#print("Init Rotation Y: " + str(rad_to_deg($Attack.rotation.y)))
			$Attack.rotation.y = lerp_angle($Attack.rotation.y, deg_to_rad(angle), 0.1)
			#print("Rotation Y: " + str(rad_to_deg($Attack.rotation.y)))
		"z":
			$Attack.rotation.z = lerp_angle($Attack.rotation.z, deg_to_rad(angle), 0.1)
			
func _process(_delta: float) -> void:
	match health_shake_state:
		0:
			_shake_healthbar(10)
		1:
			_shake_healthbar(0)
		2:
			_shake_healthbar(-10)
		3: 
			_shake_healthbar(0)
	$AttackTiming.text = str(int($Timer.get_time_left() + 1))
	
func _physics_process(_delta: float) -> void:
	if alive:
		match attack_choice:
			0:
				pass
			1: # Attack from left to right
				_rotate_attack(0, "y")
			2: # Attack from up to down
				_rotate_attack(0, "x")
			3:
				pass
	
func _on_health_bar_timer_timeout() -> void:
	count += 1
	match health_shake_state:
		0:
			health_shake_state = 1
			$HealthBarTimer.start()
			
		1:
			health_shake_state = 2
			$HealthBarTimer.start()
		2:
			health_shake_state = 3
			$HealthBarTimer.start()
		3:
			health_shake_state = 0
			$HealthBarTimer.start()
	if count >= 7:
		count = 0
		$HealthBarTimer.stop()

func _on_enemy_cd_timer_timeout() -> void:
	attack_choice = 0
	rand_attack_choice = randi_range(1,2)
	match rand_attack_choice:
		1:
			$Attack.rotation.y = deg_to_rad(-25)
			$Attack.rotation.x = deg_to_rad(0)
		2:
			$Attack.rotation.x = deg_to_rad(-25)
			$Attack.rotation.y = deg_to_rad(0)
	$EnemyCDTimer.stop()
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == $"../Player":
		print("HIT")
		get_parent().get_node("Player")._lose_health(1)
