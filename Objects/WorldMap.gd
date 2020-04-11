extends Node2D

var home_tile = Vector2()
onready var map_size  # Get from map node
enum ACTIONS {EXPLORE, INVADE}
var exploration_mode = 0
var move_directions = {'N': Vector2(0,-1), 
						'S': Vector2(0,1),  
						'NE': Vector2(1,-1), 
						'SE':  Vector2(1,0), 
						'NW':  Vector2(-1,0), 
						'SW':  Vector2(-1,1)}
var last_tile_pressed = Vector2()

func _ready():
	map_size = $Map.map_size
	home_tile = Vector2(map_size-1, 2*(map_size-1))
	make_player_controlled(home_tile, true)
	#make_player_controlled(Vector2(2,2), true)
	#make_player_controlled(Vector2(2,3), true)
	switch_action(exploration_mode)
	update_visibility()

func _tile_pressed(tile_pos):
	last_tile_pressed = tile_pos
	highlight_last_pressed(true)
	$ActionHUD/VBoxContainer/ConfirmSelect/ConfirmAction.disabled = false
	print('Tile pressed: ', tile_pos)

func highlight_last_pressed(flag):
	var last_pressed_position = get_tile_in_pos(last_tile_pressed)
	if last_pressed_position:
		last_pressed_position.highlight(flag)

func _on_ConfirmAction_pressed():
	if exploration_mode:
		get_tile_in_pos(last_tile_pressed).tile_explored = true
	else:
		get_tile_in_pos(last_tile_pressed).faction = 0
	update_visibility()


func get_tile_in_pos(pos):
	for tile in $Map.get_children():
		if tile.map_pos == pos:
			return tile
	return 

func make_player_controlled(map_pos, update_exploration=false):
	for tile in $Map.get_children():
		if tile.map_pos == map_pos:
			tile.update_faction(0)
			if update_exploration:
				tile.update_explored(true)

func switch_action(action):
	exploration_mode = action == 0
	# Disable current button
	$ActionHUD/VBoxContainer/TerritorySelect/ExploreButton.disabled = exploration_mode
	$ActionHUD/VBoxContainer/TerritorySelect/AttackButton.disabled = !exploration_mode
	if exploration_mode:
		$ActionHUD/VBoxContainer/ConfirmSelect/ConfirmAction.text = "I'm ready to explore"
		# Only allow selecting own territory and adjacent
	else:
		$ActionHUD/VBoxContainer/ConfirmSelect/ConfirmAction.text = "I'm ready to invade"
		# Only allow selecting adjacent territory
	$ActionHUD/VBoxContainer/ConfirmSelect/ConfirmAction.disabled = true
	highlight_last_pressed(false)
	last_tile_pressed = Vector2()
	update_visibility()
	
func _on_ExploreButton_pressed():
	switch_action(0)

func _on_AttackButton_pressed():
	switch_action(1)

func update_visibility():
	# Show all explored tiles and own tiles, and adjancet to those too
	print('Own: ', own_tiles_list())
	print('Explored: ', explored_tiles_list())
	print('Curent: ', current_map_list())
	# First hide all tiles
	for tile in $Map.get_children():
		tile.tile_visible = false
	
	for tile_pos in current_map_list():
		for tile in $Map.get_children():
			if tile.map_pos == tile_pos:
				tile.tile_visible = true
	pass

func own_tiles_list():
	var own_list = []
	for tile in $Map.get_children():
		if tile.faction == 0:
			own_list.append(tile.map_pos)
	return own_list

func explored_tiles_list():
	var explore_list = []
	for tile in $Map.get_children():
		if tile.tile_explored:
			explore_list.append(tile.map_pos)
	return explore_list

func current_map_list(only_adjacent = false):
	#var current_list = own_tiles_list() + explore_tiles_list()
	#var current_list = own_tiles_list()
	var current_list = explored_tiles_list()
	#for tile_pos in explored_tiles_list():
	#	if !(tile_pos in  current_list):
	#		current_list.append(tile_pos)
	
	var adjacent_list = []
	for current_tile in current_list:
		for direction_key in move_directions:
			# If there is a tile in that position after the move, and tile not in list
			var test_position = current_tile + move_directions[direction_key]
			for tile in $Map.get_children():
				if tile.map_pos == test_position and \
					!(test_position in current_list) and \
					!(test_position in adjacent_list):
					adjacent_list.append(test_position)
	
	if only_adjacent:
		return adjacent_list
	return current_list + adjacent_list



