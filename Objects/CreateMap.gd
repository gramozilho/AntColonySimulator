tool
extends Node2D

const HexagonTile = preload("res://HUD/Overlay.tscn")
const tile_distance = Vector2(240, 115)

export var map_size = 3 
export var update_map_size = false setget set_map_size
#export var update_map_default = false setget set_default_map

func _ready():
	for tile in get_children():
		tile.connect("pressed", get_parent(), "_tile_pressed")
		make_tile_connections(tile)

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
				new_tile.faction = randi()%5+1
				#make_tile_connections(new_tile)
				
				add_child(new_tile)
				new_tile.set_owner(get_tree().get_edited_scene_root())

func make_tile_connections(tile):
	tile.connect("input_event", tile, "_on_OverlayCell_input_event")
	tile.connect("mouse_entered", tile, "_on_OverlayCell_mouse_entered")
	tile.connect("mouse_exited", tile, "_on_OverlayCell_mouse_exited")

func set_map_size(_flag):
	if Engine.editor_hint and (get_tree() != null):
		#map_size = new_size
		map_maker()
		print('Map updated')
	else:
		print('Not in editor, skip map update')

func set_default_map(_flag):
	if Engine.editor_hint and (get_tree() != null):
		print('Updating map default')
		var data = {}
		for tile in self.get_children():
			data[tile.map_pos] = tile.summary()
		print(data)
		print('Now copy this into the SaveAndLoad default world')
	else:
		print('Not in editor, skip map default update')
