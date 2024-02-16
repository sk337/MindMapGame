extends Node2D
# the path to the JSON file
var json_path = "res://data/NeuronsData.json"
var term_scene_path = "res://scenes/Term.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	var json_data = load_and_parse_json()
	if json_data != null:
		process_json(json_data)
	# instantiate_term("Example Term", Vector2(200,200))

# Function to load content from a JSON file
func load_and_parse_json():
	var file = FileAccess.open(json_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close() #explicitly close the file
		
		var my_json := JSON.new()
		var parse_result := my_json.parse(json_text)
		if parse_result == OK:
			return my_json.get_data() #successfully parsed JSON data
		else:
			print(parse_result)
			print("Failed to parse JSON " , my_json.get_error_message(), " in ", json_text, " at line ", my_json.get_error_line())
	else:
		print("filed to open file at path:", json_path)
	return null
	
# Placeholder function to do something with parsed data
func process_json(json_data):
	#print(json_data)
	var current_position = Vector2(50, 50)
	var term_offset = Vector2(0, 60)
	var column_width = 200 #width of each term
	if json_data.size() > 0:
		var just_items = json_data["just_items"]
		if just_items.size() > 0:
			for i in range(just_items.size()):
				var term_name = just_items[i]
				current_position = current_position + term_offset # staggered position
				instantiate_term(term_name, current_position)

func instantiate_term(term_name: String, position: Vector2):
	var term_scene: PackedScene = load(term_scene_path)
	if term_scene:
		var term_instance = term_scene.instantiate()
		add_child(term_instance)
		term_instance.position = position
		term_instance.get_node("RichTextLabel").text = term_name #set the term name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
