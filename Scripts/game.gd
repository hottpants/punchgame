extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Reset enemy/player stuff at the beginning of a new round
func reset():
	$Node3D/Enemy.reset()
	$Node3D/Player.reset()
