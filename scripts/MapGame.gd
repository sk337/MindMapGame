extends Node2D
# the path to the JSON file
var json_path = "res://data/NeuronsData.json"
var term_scene_path = "res://scenes/Term.tscn"
enum Tools {MOVE, CONNECT}
var current_tool = Tools.MOVE

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
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
	var column_width = 150 #width of each term
	var screen_height = DisplayServer.screen_get_size().y # get the window height
	
	if json_data.size() > 0:
		var just_items = json_data["just_items"]
		var item_data = json_data["item_data"]
		var term_index = 0
		var term_level = 0
		var term_category_ranks = {"cat 1": 1.0, "cat 2": 0.5}
		var term_term_ranks = {"term 1": 1.0, "term 2": 0.5}
		
		if just_items.size() > 0:
			for i in range(just_items.size()):
				var term_name = just_items[i]
				var term_dict = null
				# find the dicitonary for the term
				for data in item_data:
					if data["name"] == term_name:
						term_dict = data
						break
				# if term data was found, get the details
				if term_dict:
					term_index = i # the loop index is the term index
					term_level = int(term_dict["level"])
					term_category_ranks = term_dict["categories"]
					term_term_ranks = term_dict["relatedness"]
				if current_position.y + term_offset.y > screen_height:
					#start a new column
					current_position.y = term_offset.y
					current_position.x += column_width
				current_position += term_offset # staggered position
				instantiate_term(term_name, current_position, term_index, term_level, term_category_ranks, term_term_ranks)

func instantiate_term(term_name: String, my_position: Vector2, index: int, level: int, category_ranks: Dictionary, term_ranks: Dictionary):
	var term_scene: PackedScene = load(term_scene_path)
	if term_scene:
		var term_instance = term_scene.instantiate()
		add_child(term_instance)
		term_instance.position = my_position
		term_instance.get_node("RichTextLabel").text = term_name #set the term name
		term_instance.term_index = index
		term_instance.term_level = level
		term_instance.category_ranks = category_ranks
		term_instance.term_ranks = term_ranks
		term_instance.add_to_group("terms") #add to the group "terms"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if current_tool == Tools.MOVE:
		pass # done in script for items
	elif current_tool == Tools.CONNECT:
		pass

func _on_move_tool_button_pressed():
	current_tool = Tools.MOVE
	for term in get_tree().get_nodes_in_group("terms"):
		term.set_tool_mode("move")

func _on_connect_terms_tool_button_pressed():
	current_tool = Tools.CONNECT
	for term in get_tree().get_nodes_in_group("terms"):
		term.set_tool_mode("connect")
