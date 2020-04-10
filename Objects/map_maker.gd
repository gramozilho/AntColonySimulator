extends Node

const HexagonTile = preload("res://HUD/Overlay.tscn")
const map_size = 2
const tile_distance = 170

func _ready():
	map_maker()

func map_maker():
	for y in range(map_size):
		for x in range(map_size):
			var new_tile = HexagonTile.instance()
			new_tile.position = Vector2(x*tile_distance, y*tile_distance)
			$Map.add_child(new_tile)
