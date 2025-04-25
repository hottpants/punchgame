extends Control

## SIGNALS

signal item_sold(item)

## MISC VARS

var item
var button : Button

func _ready() -> void:
	print(str($Area2D.is_pickable()))
	pass

# Initializes item
func init_item(_item : Dictionary):	
	item = _item	
	$Label.text = item["Name"]
	
	# Get size of text and set the label to that size in order to properly format multiple items
	
	var string_size = $Label.get_theme_font("font").get_string_size($Label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, $Label.get_theme_font_size("font_size"))
	$Label.size = Vector2(string_size)
	
	# Set the size of the rest of the nodes to the label size
	
	self.size = $Label.size
	$Area2D/CollisionShape2D.shape.extents = $Label.size

# 
func show_button():
	button = Button.new()
	button.size = $Label.size
	#button.position = $Label.position + $Label.size/2
	$Label.add_child(button)
	button.pressed.connect(sell_item)
	button.text = "Sell"
	button.theme = load("res://Resources/SellButtonTheme.tres")
	#button.mouse_exited.connect(hide_button)
	
func sell_item():
	item_sold.emit(item)
	queue_free()

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if button != null and !is_mouse_over():
		hide_button()

func is_mouse_over():
	var mouse_pos = get_global_mouse_position()
	var rect = Rect2(button.global_position, button.size)
	return rect.has_point(mouse_pos)

func _on_mouse_entered() -> void:
	show_button()

func hide_button():
	if button != null:
		button.queue_free()
