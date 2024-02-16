extends Node2D

# the path to the JSON file
var json_path = "res://data/NeuronsData.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	var json_data = load_and_parse_json()
	if json_data != null:
		process_json(json_data)

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
	print(json_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
