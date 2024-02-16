extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	if theme == null:
		var new_theme := Theme.new()
		theme = new_theme
	# Set the text color to black
	var new_color = Color(0, 0, 0, 1) #Black color
	theme.set_color("default_color", self.get_class(), new_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
