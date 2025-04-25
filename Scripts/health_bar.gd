extends ProgressBar

## SIGNALS

signal health_zero # Signal emitted when health is zero

## NODES

@onready var damage_bar = $DamageBar # Damage bar (grey progress bar)
@onready var timer = $Timer # Timer which delays when the damage bar is decreased

## HEALTH VARS

var health = 0 #: set = _set_health # Health value 

# Set health equal to a new health (from taking damage or healing or whatnot)
func _set_health(new_health):
	var prev_health = health
	
	# Sets health equal to the lower value between the max value of the progress bar and the new health
	
	health = min(max_value, new_health)
	
	# Sets current value of progress bar to health
	
	value = health
	
	if health <= 0: # If health is 0 or less, emits signal to enemy and then kills itself
		health_zero.emit()
		queue_free()
	
	if health < prev_health: # If health is less than previous health (taking damage as opposed to healing), start timer for grey bar to go down
		timer.start()
	
	else: # Else, heal
		damage_bar.value = health

# Initialize health to _health. Function is called from enemy
func init_health(_health):
		health = _health
		# Max value of health progress bar and current value of progress bar get set to health value passed from function
		
		max_value = health
		value = health
		
		# Max value of damage progress bar and current value of progress bar get set to health value passed from function
		
		damage_bar.max_value = health
		damage_bar.value = health

# When timer times out, set damage bar value equal to new health (would like to more gradually decrease damage_bar value
func _on_timer_timeout() -> void:
	damage_bar.value = health
