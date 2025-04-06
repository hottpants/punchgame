extends CharacterBody3D

class_name Enemy

@onready var enemy_health_bar = $enemy_health_bar

var enemy_damage : float
var health_shake_state : int
var count : int
@onready var timer = $DamageTimer
@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health


func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
		
		if health < prev_health:
			timer.start()
			
		else:
			damage_bar.value = health

func init_health(_health):
		health = _health
		max_value = health
		value = health
		damage_bar.max_value = health
		damage_bar.value = health
		
		
#func _on_timer_timeout() -> void:
	#damage_bar.value = health
	
func _ready() -> void:
	enemy_damage = 10
	health_shake_state = 3

	count = 0
	$Timer.start()
	
func _damage_enemy(damage: float):
	$HealthBarViewport/EnemyHealthBar.set_value($HealthBarViewport/EnemyHealthBar.get_value() - damage)

	health_shake_state = 0
	$HealthBarTimer.start()
	

func _enemy_attack():
	get_parent().get_node("Player")._lose_health(1)
	
func _on_timer_timeout() -> void:
	print("ASS")
	_enemy_attack()
	$Timer.start()

func _shake_healthbar(angle):
	$EnemyHealthSprite.rotation.z = lerp_angle(rotation.z, deg_to_rad(angle), 0.1)

func _process(delta: float) -> void:
	match health_shake_state:
		0:
			_shake_healthbar(10)
		1:
			_shake_healthbar(0)
		2:
			_shake_healthbar(-10)
		3: 
			_shake_healthbar(0)


func _on_health_bar_timer_timeout() -> void:
	count += 1
	match health_shake_state:
		0:
			health_shake_state = 1
			print(health_shake_state)
			$HealthBarTimer.start()
			
		1:
			health_shake_state = 2
			print(health_shake_state)
			$HealthBarTimer.start()
		2:
			health_shake_state = 3
			print(health_shake_state)
			$HealthBarTimer.start()
		3:
			health_shake_state = 0
			print(health_shake_state)
			$HealthBarTimer.start()
	if count >= 7:
		count = 0
		$HealthBarTimer.stop()
	if count >= 10:
		count = 0
		$EPICTIMER.start()


func _on_epictimer_timeout() -> void:
	$HealthBarTimer.start()


func _on_damage_bar_timer_timeout() -> void:
	pass # Replace with function body.
