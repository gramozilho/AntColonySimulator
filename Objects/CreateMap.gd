tool
extends Node2D

const HexagonTile = preload("res://HUD/Overlay.tscn")
const tile_distance = Vector2(240, 115)

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
	
	var base_displacement = -Vector2((map_size-1)*tile_distance.x/2, 
		(map_size-1)*tile_distance.y + (map_size-1)/2.0*tile_distance.y )
	# Create new ones
	for y in range(2*map_size-1):
		for x in range(2*map_size-1):
			
			if ((y+x) >= map_size-1) and ((y+x) <= ((map_size-1)*3)):
			
				var new_tile = HexagonTile.instance()
				var x_displacement = x*tile_distance.x/2 + base_displacement.x
				var y_displacement = y*tile_distance.y + x/2.0*tile_distance.y + base_displacement.y
				new_tile.position = Vector2(x_displacement, y_displacement)
				# Add info from file
				new_tile.map_pos = Vector2(x, y)
				
				#new_tile.set_owner(get_node("Map"))
				add_child(new_tile)
				new_tile.set_owner(get_tree().get_edited_scene_root())


func set_map_size(new_size):
	if Engine.editor_hint:
		map_size = new_size
		map_maker()
		print('Map updated')
