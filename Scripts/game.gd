extends CanvasLayer

var stage : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _set_stage(new_stage : int):
	stage = new_stage

func reset():
	print("MASSIVE PEENOR!")
	$Node3D/Enemy.reset()
	#$Node3D/Player.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
