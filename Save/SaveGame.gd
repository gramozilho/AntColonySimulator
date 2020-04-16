extends Resource

class_name SaveGame

export var game_version : String = ""
export var data: Dictionary = {} 


func save() -> Dictionary:
	# Save base colony data
	var save_data =  {
		'resources': {
			'ants': ants, 'food': food
		}, 
		'upgrades': {
			'max_ants': max_ants, 'max_food': max_food
		}
	}
	# Save map data
	var map_data = {}
	var i = 0
	for tile_key in map_data:
		map_data[i] = save_tile(map_data[tile_key])
		i += 1
	save_data['map_data'] = map_data
	
	return save_data

func save_tile(dict) -> Dictionary:
	return {"map_pos_x": dict.map_pos.x, "map_pos_y": dict.map_pos.y, \
		"faction": dict.faction, "tile_explored": dict.tile_explored}

func load(data) -> void:
	ants = data['resources']['ants']
	food = data['resources']['food']
	max_ants = data['upgrades']['max_ants']
	max_food = data['upgrades']['max_food']
	update_hud()
