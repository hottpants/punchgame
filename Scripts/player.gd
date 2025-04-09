extends CharacterBody3D

@export var speed = 14

signal decrease_enemy_health(damage)

var target_velocity = Vector3.ZERO
var rotate_status = 0
var stam_drain : float
var stam_recovery : float
var stam_CD_min : float
var light_damage : float
var heavy_damage : float
var stam_light_min : float
var stam_heavy_min : float
var health : int

func _ready() -> void:
	stam_drain = 2
	stam_recovery = 0.5
	stam_CD_min = 25
	light_damage = 5
	heavy_damage = 15
	stam_light_min = 2
	stam_heavy_min = 35
	health = 3
	
	pass
	
	
func _physics_process(delta: float) -> void:
	
	
	# _physics_process is super weird and only constantly runs IF something is happening (I think) which is why when you HOLD the a button
	# it moves left slowly but when you RELEASE the a button it snaps back. I figured this out by printing when different values were changed
	
	# The following if statements check for if you have enough stamina/focus to dodge as well as whether or not you are in the process of dodging
	
	# 0 = static
	# 1 = moving to left from static
	# 2 = returning to static from left/right
	# 3 = moving to right from static
	# 4 = moving down from static
	# 5 = returning to static from down
	
	# Dodging left
	if rotate_status == 0 and $FocusMeter.get_value() > stam_CD_min:
		if Input.is_action_pressed("dodge_left"):
			rotate_status = 1
	
	# Returning from dodging left
	if rotate_status == 1:
		if Input.is_action_just_released("dodge_left") or $FocusMeter.get_value() <= 1:
			rotate_status = 2
	
	# Dodging right
	if rotate_status == 0 and $FocusMeter.get_value() > stam_CD_min:
		if Input.is_action_pressed("dodge_right"):
			rotate_status = 3
	
	# Returning from dodging right
	if rotate_status == 3:
		if Input.is_action_just_released("dodge_right") or $FocusMeter.get_value() <= 1:
			rotate_status = 2
	
	# Ducking/Dodging down
	if rotate_status == 0 and $FocusMeter.get_value() > stam_CD_min:
		if Input.is_action_pressed("dodge_down"):
			rotate_status = 4
	
	# Returning from duck/dodging down
	if rotate_status == 4:
		if Input.is_action_just_released("dodge_down") or $FocusMeter.get_value() <= 1:
			rotate_status = 5
	
	
	if Input.is_action_just_pressed("attack_light") and rotate_status == 0 and $FocusMeter.get_value() > stam_light_min:
		$FocusMeter.set_value($FocusMeter.get_value() - 10 * stam_light_min)
		get_parent().get_node("Enemy")._damage_enemy(light_damage)
	
	if Input.is_action_just_pressed("attack_heavy") and rotate_status == 0 and $FocusMeter.get_value() > stam_heavy_min:
		$FocusMeter.set_value($FocusMeter.get_value() - stam_heavy_min)
		get_parent().get_node("Enemy")._damage_enemy(heavy_damage)
	
	if Input.is_action_just_pressed("change_to_shop"):
		get_tree().change_scene_to_file("res://Scenes/shop.tscn")
	
	
func _process(delta: float) -> void:
	
	# The following comments in the match function are the print statements I used to debug
	match health:
		0:
			$Heart1.self_modulate.a = 0.1
		1: 
			$Heart2.self_modulate.a = 0.1
		2:
			$Heart3.self_modulate.a = 0.1
		3:
			pass
	match rotate_status:
		0:
			$FocusMeter.set_value($FocusMeter.get_value() + stam_recovery)
		1:
			#print(str(rotate_status) +":"+ str(rad_to_deg(rotation.y)))
			rotation.y = lerp_angle(rotation.y, deg_to_rad(-30), speed * delta)
			$FocusMeter.set_value($FocusMeter.get_value() - stam_drain)
		2:
			#print(str(rotate_status) +":"+ str(rad_to_deg(rotation.y)))
			rotation.y = lerp_angle(rotation.y, deg_to_rad(0), speed * delta)
			$FocusMeter.set_value($FocusMeter.get_value() + stam_recovery)
		3:
			#print(str(rotate_status) +":"+ str(rad_to_deg(rotation.y)))
			rotation.y = lerp_angle(rotation.y, deg_to_rad(30), speed * delta)
			$FocusMeter.set_value($FocusMeter.get_value() - stam_drain) 
		4:
			#print(str(rotate_status) +":"+ str(rad_to_deg(rotation.y)))
			rotation.x = lerp_angle(rotation.x, deg_to_rad(15), speed * delta)
			$FocusMeter.set_value($FocusMeter.get_value() - stam_drain) 
		5:
			#print(str(rotate_status) +":"+ str(rad_to_deg(rotation.x)))
			rotation.x = lerp_angle(rotation.x, deg_to_rad(0), speed * delta)
			$FocusMeter.set_value($FocusMeter.get_value() + stam_recovery)
		_:
			pass
			
	# Check to see if the rotation is back to default. If so, set the rotate_status integer to 0
	if int(rad_to_deg(rotation.y)) == 0 and int(rad_to_deg(rotation.x)) == 0:
		rotation.y = 0
		rotate_status = 0

func _lose_health(amount: int):
	health -= amount
