extends Sprite3D

## NODES

@onready var timer = $Timer # Timer length determines how long the damage sprite should be on screen before freeing itself
@onready var dmg_label = $SubViewport/DamageLabel # Label holds the text containing the damage amount

# Sets the label text equal to the amount of damage dealt
func set_damage(damage : int):
	dmg_label.text = str(damage)

func _ready() -> void:
	
	# Initializes position at enemy body for a specific height and depth, but the width location is random between -1.0 and 1.0 for variation
	
	position = Vector3(randf_range(-1.0,1.0), 1.5, -4)
	
	# Start timer to free self
	
	timer.start()
	
func _process(_delta: float) -> void:
	
	# Go up and become more transparent over time
	
	position.y += 0.01
	self.modulate.a -= 0.01

func _on_timer_timeout() -> void:
	
	# Free self once timer times out
	
	queue_free()
