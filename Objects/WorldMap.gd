extends Node2D

var home_tile = Vector2()
onready var map_size  # Get from map node
enum ACTIONS {EXPLORE, INVADE}
#var exploration_mode = 0
var move_directions = {'N': Vector2(0,-1), 
						'S': Vector2(0,1),  
						'NE': Vector2(1,-1), 
						'SE':  Vector2(1,0), 
						'NW':  Vector2(-1,0), 
						'SW':  Vector2(-1,1)}
#var last_tile_pressed = Vector2()
const explore_button_text = "Explore selected tile"
const invade_button_text = "Invade selected tile"
const no_tile_selection_text = ""
#var map_data = {}
#var map_data = ColonyManager.map_data


func _ready() -> void:
	WorldVariables.party["ants"] = 0
	WorldVariables.selected_territory = Vector2()
	
	map_size = $Map.map_size
	home_tile = Vector2(map_size-1, 2*(map_size-1))
	if len(WorldVariables.map_data)==0:
		make_player_controlled(home_tile, true)
		WorldVariables.temp_initialize_map_data(get_node("Map"))
	else:
		load_map()
	#make_player_controlled(Vector2(2,2), true)
	#make_player_controlled(Vector2(2,3), true)
	switch_action(0)
	update_visibility()
	show_loot()

func load_map():
	for key in WorldVariables.map_data:
		#print('load ', ColonyManager.map_data[key], ' key ', key)
		get_tile_in_pos(key).populate(WorldVariables.map_data[key])

func _tile_pressed(tile_pos) -> void:
	highlight_last_pressed(false)
	WorldVariables.selected_territory = tile_pos
	highlight_last_pressed(true)
	$ActionHUD/VBoxContainer/ConfirmSelect/ConfirmAction.release()  #disabled = false
	var selected_tyle = get_tile_in_pos(tile_pos)
	if selected_tyle.tile_explored:
		$ActionHUD/VBoxContainer/TerritorySelect/TerritorySelected.text = get_tile_in_pos(tile_pos).get_faction_name()
	else:
		$ActionHUD/VBoxContainer/TerritorySelect/TerritorySelected.text = "???"
	#print('Tile pressed: ', tile_pos)

func highlight_last_pressed(flag):
	var last_pressed_position = get_tile_in_pos(WorldVariables.selected_territory)
	if last_pressed_position:
		last_pressed_position.highlight(flag)
	if !flag:
		$ActionHUD/VBoxContainer/TerritorySelect/TerritorySelected.text = no_tile_selection_text


func _on_ConfirmAction_pressed() -> void:
	if WorldVariables.party["ants"] == 0:
		# Shake party selector
		$ActionHUD/VBoxContainer/PartySelect/Shake.shake()
		$ActionHUD/VBoxContainer/PartySelect/ErrorMsg.text = "(minimum 1)"
	else:
		$ActionHUD/VBoxContainer/PartySelect/ErrorMsg.text = " "
	if WorldVariables.selected_territory == Vector2():
		# Shake selection
		$ActionHUD/VBoxContainer/TerritorySelect/Shake.shake()
		$ActionHUD/VBoxContainer/TerritorySelect/TerritorySelected.text = "(none)"
	if (WorldVariables.party["ants"] == 0) or \
		(WorldVariables.selected_territory == Vector2()):
		return
	SceneManager.go_to("temp")

func old_confirmAction():
	if WorldVariables.exploration_mode:
		get_tile_in_pos(WorldVariables.selected_territory).tile_explored = true
	else:
		get_tile_in_pos(WorldVariables.selected_territory).faction = 0
	#highlight_last_pressed(false)
	WorldVariables.selected_territory = Vector2()
	update_visibility()
	#$ActionHUD/VBoxContainer/TerritorySelect/TerritorySelected.text = no_tile_selection_text


func get_tile_in_pos(pos):
	for tile in $Map.get_children():
		if tile.map_pos == pos:
			return tile
	return 

func make_player_controlled(map_pos, update_exploration=false) -> void:
	for tile in $Map.get_children():
		if tile.map_pos == map_pos:
			tile.update_faction(0)
			if update_exploration:
				tile.update_explored(true)

func switch_action(action) -> void:
	var explore_selected = action == 0
	WorldVariables.exploration_mode = explore_selected
	# Disable current button
	if explore_selected:
		$ActionHUD/VBoxContainer/ActionSelect/ExploreButton.lock_pressed()
		$ActionHUD/VBoxContainer/ActionSelect/AttackButton.release()
	else:
		$ActionHUD/VBoxContainer/ActionSelect/ExploreButton.release()
		$ActionHUD/VBoxContainer/ActionSelect/AttackButton.lock_pressed()
	
	if explore_selected:
		$ActionHUD/VBoxContainer/ConfirmSelect/ConfirmAction.text = explore_button_text
		# Only allow selecting own territory, already explored and adjacent to both
		update_selection(current_map_list())
	else:
		$ActionHUD/VBoxContainer/ConfirmSelect/ConfirmAction.text = invade_button_text
		# Only allow selecting adjacent and explored territory
		update_selection(invadable_tile_list())
	#$ActionHUD/VBoxContainer/TerritorySelect/TerritorySelected.text = no_tile_selection_text
	
	#$ActionHUD/VBoxContainer/ConfirmSelect/ConfirmAction.disabled = true
	highlight_last_pressed(false)
	WorldVariables.selected_territory = Vector2()
	update_visibility()

func update_selection(new_list) -> void:
	for tile in $Map.get_children():
		if tile.map_pos in new_list:
			tile.tile_selectable = true
		else:
			tile.tile_selectable = false


func _on_ExploreButton_pressed() -> void:
	switch_action(0)

func _on_AttackButton_pressed() -> void:
	switch_action(1)

func update_visibility() -> void:
	# Show all explored tiles and own tiles, and adjancet to those too
	# First hide all tiles
	for tile in $Map.get_children():
		tile.tile_visible = false
	
	for tile_pos in current_map_list():
		for tile in $Map.get_children():
			if tile.map_pos == tile_pos:
				tile.tile_visible = true
	
	# Save new map
	for tile in $Map.get_children():
		WorldVariables.map_data[tile.map_pos] = tile.summary()

func own_tiles_list():
	var own_list = []
	for tile in $Map.get_children():
		if tile.faction == 0:
			own_list.append(tile.map_pos)
	return own_list

func invadable_tile_list():
	# Select all tiles that have been explored but are not your own
	var invaded_list = []
	for tile_pos in explored_tiles_list():
		if get_tile_in_pos(tile_pos).faction != 0:
			invaded_list.append(tile_pos)
	
	return invaded_list

func explored_tiles_list():
	# Return all tiles that have been explored
	var explore_list = []
	for tile in $Map.get_children():
		if tile.tile_explored:
			explore_list.append(tile.map_pos)
	return explore_list

func current_map_list(only_adjacent = false):
	# Return all tiles that have been explored and their adjacents
	#var current_list = own_tiles_list() + explore_tiles_list()
	var current_list = own_tiles_list()
	#var current_list = explored_tiles_list()
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

#func save() -> Dictionary:
#	var data_out = {}
#	var i = 0
#	for tile in $Map.get_children():
#		data_out[i] = tile.summary()
#		i += 1
#	return data_out


func _on_BaseSceneButton_pressed():
		SceneManager.go_to("base")

func show_loot():
	var recent_loot = WorldVariables.recent_loot
	if recent_loot != {}:
		print('World loot ', recent_loot)
		WorldVariables.recent_loot = {}
