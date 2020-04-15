extends Node

var food = 5 setget update_food
var max_food = 10 setget update_max_food
var ants = 10 setget update_ants
var max_ants = 20 setget update_max_ants

var prices = {'ants': 1, 'max_ants':1, 'max_food': 1}
var map_data = {}

func _ready() -> void:
	update_hud()

func update_food(change) -> void:
	food = min(food + change, max_food)
	update_hud()
	
func update_max_food(new_value) -> void:
	max_food += new_value
	update_hud()
	
func update_ants(change) -> void:
	ants = min(ants + change, max_ants)
	update_hud()
	
func update_max_ants(new_value) -> void:
	max_ants += new_value
	update_hud()

func update_hud() -> void:
	$VBoxContainer/Food.text = "Food: " + str(food) + "/" + str(max_food)
	$VBoxContainer/Ants.text = "Ants: " + str(ants) + "/" + str(max_ants)

func _on_LoadBase_pressed() -> void:
	SceneManager.go_to("base")

func _on_LoadMap_pressed() -> void:
	SceneManager.go_to("map")

func buy_inquire(key) -> bool:
	# For shop use. If food amount can be subtracted, do so and return true.
	if food >= prices[key]:  # If there is enough food for this purchase
		food -= prices[key]
		return true
	return false

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
	#return {'map_pos': map_pos, 'faction': faction, 'tile_explored': tile_explored}
	return {"map_pos_x": dict.map_pos.x, "map_pos_y": dict.map_pos.y, \
		"faction": dict.faction, "tile_explored": dict.tile_explored}

func load(data) -> void:
	#for key in data:
	#	for variable in data[key]:
	#		get(variable) = data[key][variable]
	ants = data['resources']['ants']
	food = data['resources']['food']
	max_ants = data['upgrades']['max_ants']
	max_food = data['upgrades']['max_food']
	update_hud()

