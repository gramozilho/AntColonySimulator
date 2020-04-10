tool
extends Node2D

const HexagonTile = preload("res://HUD/Overlay.tscn")
const tile_distance = Vector2(180/2, 120/2)

export var map_size = 2 setget set_map_size
var map_info = {}

func _ready():
	pass

func map_maker():
	# Clean current map nodes
	if get_child_count() > 0:
		print('Delete old map')
		for old_tile in get_children():
			old_tile.free()
	
	# Create new ones
	for y in range(2*map_size-1):
		for x in range(2*map_size-1):
			
			if ((y+x) >= map_size-1) and ((y+x) <= map_size*2+1):
			
				var new_tile = HexagonTile.instance()
				var x_displacement = (x)*tile_distance.x
				var y_displacement = -(y+x-map_size-1)*tile_distance.y
				new_tile.position = Vector2(x_displacement, y_displacement)
				new_tile.army_size.text = "aa" 1 #"(" #+ str(x) + "," + str(y) + ")"
				# Add info from file
				
				#$Map.set_owner(new_tile)
				add_child(new_tile)


func set_map_size(new_size):
	if true: #Engine.editor_hint:
		print('Updating map')
		map_size = new_size
		map_maker()
