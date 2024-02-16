extends Node2D

var drag_offset = Vector2()
var dragging = false
var original_z_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var color_rect = get_node("ColorRect") as ColorRect
		# Convert mouse event position to the Node2D's local space
		var local_mouse_pos = to_local(event.global_position)
		var rect_min_pos = color_rect.position
		var rect_max_pos = rect_min_pos + color_rect.size
		#print("event: ", event)

		# Check if the click is within the bounds of the ColorRect
		if event.pressed and local_mouse_pos.x >= rect_min_pos.x and local_mouse_pos.y >= rect_min_pos.y and local_mouse_pos.x <= rect_max_pos.x and local_mouse_pos.y <= rect_max_pos.y:
			drag_offset = rect_min_pos - to_local(event.global_position)
			dragging = true
			#print("Dragging: ", dragging)
			# Optionally, raise to ensure it's drawn on top while moving
			z_index = 1000 # temporarily set a high z_index to draw it on top
		elif not event.pressed and dragging:
			dragging = false
			#print("Dragging: ", dragging)
			z_index = original_z_index

	if event is InputEventMouseMotion and dragging:
		global_position = event.global_position + drag_offset
		#print("Dragging: ", dragging, " Position: ", global_position)

func set_text(content: String):
	var rich_text_label = get_node("RichTextLabel") as RichTextLabel
	rich_text_label.bbcode_text = content

func connect_to(other_term: Node2D):
	var line = get_node("Line2D") as Line2D
#	line.points = PoolVector2Array([position, other_term.position])
# note to self - create a PoolVector2Array function later

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
