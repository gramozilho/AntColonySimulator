extends Node2D

var path = "user://data.json"

# Default values
var default_data = {
	"ColonyManager": {
		"resources": {
			"ants": 5,
			"food": 0
		},
		"upgrages": {
			"max_ants": 10,
			"max_food": 10
		}
	},
	"WorldMap": {
		"map_data": { 
			Vector2(0,0): {
				'map_pos': Vector2(0,0), 
				'faction': 0, 
				'tile_explored': true
				}
			}
		}
	}

var default_map = {Vector2(0, 3):{
	"faction":0, "map_pos":Vector2(0, 3), "tile_explored":false}
	}

var data = {}

func _ready():
	pass #load_game()
	#update_data()


func load_game():
	var file = File.new()
	
	if not file.file_exists(path):
		reset_data()
		return
	
	file.open(path, file.READ)
	
	var text = file.get_as_text()
	
	data = parse_json(text)
	
	file.close()


func save_game():
	# Collect data to save
	var save_nodes = get_tree().get_nodes_in_group("save")
	for node in save_nodes:
		print('Saving ', node.name)
		data[node.name] = node.save()
	print(data)
	# Write data to file
	var file
	file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	file.close()


func reset_data():
	data = default_data.duplicate(true)

func _on_SaveButton_pressed():
	save_game()


func _on_LoadButton_pressed():
	load_game()
	update_data()


func _on_DeleteButton_pressed():
	var dir = Directory.new()
	dir.remove(path)
	
	reset_data()
	
	update_data()


func update_data():
	pass
	#ColonyManager.load(data['ColonyManager'])
