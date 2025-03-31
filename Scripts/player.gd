extends CharacterBody3D

@export var speed = 14

var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var has_stam = true
	
	if int(rotation.y) <= 0:
		if Input.is_action_pressed("dodge_left") and has_stam:
			rotation.y = lerp(rotation.y, deg_to_rad(-30), 0.5) #delta * speed)
			$FocusMeter.set_value($FocusMeter.get_value() - 5)
			print($FocusMeter.get_value())
			if $FocusMeter.get_value() <= 0:
				has_stam = false
		if Input.is_action_just_released("dodge_left") or !has_stam:
			rotation.y = lerp(rotation.y, deg_to_rad(30), 0.5) #delta * speed)
			print(rotation.y)
	
	if int(rotation.y) >= 0:
		if Input.is_action_pressed("dodge_right") and has_stam:
			rotation.y = lerp(rotation.y, deg_to_rad(30), 0.5) #delta * speed)
			$FocusMeter.set_value($FocusMeter.get_value() - 5)
			if $FocusMeter.get_value() <= 0:
				has_stam = false
		if Input.is_action_just_released("dodge_right") or !has_stam:
			rotation.y = lerp(rotation.y, deg_to_rad(-30), 0.5) #delta * speed)
			print(rotation.y)
	#while $FocusMeter.get_value() < 100:
		#$FocusMeter.set_value($FocusMeter.get_value() + 1)
	#if $FocusMeter.get_value() == 100:
		#has_stam = true
func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
