extends Node


var map_data = {}
var party = {"ants": 0}
var exploration_mode = true
var recent_loot = {}
var selected_territory = Vector2()

func _ready():
	pass

func temp_initialize_map_data(ref_to_map):
	for tile in ref_to_map.get_children():
		map_data[tile.map_pos] = tile.summary()

func add_loot(loot):
	recent_loot = loot
	ColonyVariables.add_loot(loot)
	#ColonyVariables.ants += loot.ants
	#ColonyVariables.food += loot.food
	if "territory_invaded" in loot:
		map_data[selected_territory].faction = 0
	if "territory_explored" in loot:
		map_data[selected_territory].tile_explored = true

func save():
	return map_data
