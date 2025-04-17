extends Sprite3D

@onready var timer = $Timer
@onready var dmg_label = $SubViewport/DamageLabel

func set_damage(damage : int):
	dmg_label.text = str(damage)

func _ready() -> void:
	position = Vector3(0.5, 1.5, -4)
	timer.start()
	
func _process(delta: float) -> void:
	position.y += 0.01

func _on_timer_timeout() -> void:
	queue_free()
