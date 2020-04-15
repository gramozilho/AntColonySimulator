extends Node


var map_data = {}

func _ready():
	pass

func temp_initialize_map_data(ref_to_map):
	for tile in ref_to_map.get_children():
		map_data[tile.map_pos] = tile.summary()
