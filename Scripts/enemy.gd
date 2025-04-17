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
var health

@onready var pop_up_scene = load("res://Scenes/end_of_round.tscn")
@onready var enemy_health_bar

func die():
	alive = false
	loot = randi_range(5,25)
	var new_pop_up = pop_up_scene.instantiate()
	#new_pop_up.set_pivot_offset(Vector2(new_pop_up.size/2))
	$"../".add_child(new_pop_up)
	
	new_pop_up.set_position(Vector2(575.872, 324.0)-new_pop_up.size/2)
	
	new_pop_up.on_win(loot, $"../Player"._get_stage())
	
	

func reset():
	spawn_health_bar()
	enemy_max_health = 100
	enemy_health_bar.init_health(enemy_max_health)
	alive = true
	
func spawn_health_bar():
	enemy_health_bar = load("res://Scenes/health_bar.tscn").instantiate()
	$HealthBarViewport.add_child(enemy_health_bar)
	enemy_health_bar.set_position(Vector2(0,0))
	enemy_health_bar.set_size(Vector2(360,20))
	enemy_health_bar.health_zero.connect(die)
	
func _ready() -> void:
	
	enemy_max_health = 100 # Temporary
	spawn_health_bar()
	enemy_health_bar.init_health(enemy_max_health)
	alive = true
	$Attack.rotation.x = deg_to_rad(-25)
	enemy_damage = 10
	health_shake_state = 3
	
	count = 0
	$Timer.start()
	_shake_healthbar(0)
	
func _damage_enemy(damage: float):
	if alive:
		health = enemy_health_bar.health
		enemy_health_bar._set_health(health - damage)
		health_shake_state = 0
		$HealthBarTimer.start()
	

func _enemy_attack():
	if alive:
		$EnemyCDTimer.start()
	
func _on_timer_timeout() -> void:
	attack_choice = rand_attack_choice
	_enemy_attack()
	$Timer.start()

func _shake_healthbar(angle):
	$EnemyHealthSprite.rotation.z = lerp_angle(rotation.z, deg_to_rad(angle), 0.1)

func _rotate_attack(angle : int, axis : String):
	match axis:
		"x":
			
			# https://www.youtube.com/watch?v=uIU0NfO_tgQ USE THIS
			$Attack.rotation.x = lerp_angle($Attack.rotation.x, deg_to_rad(angle), 0.1)
		"y":
			$Attack.rotation.y = lerp_angle($Attack.rotation.y, deg_to_rad(angle), 0.1)
		"z":
			$Attack.rotation.z = lerp_angle($Attack.rotation.z, deg_to_rad(angle), 0.1)
			
func _process(_delta: float) -> void:
	if alive:
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
