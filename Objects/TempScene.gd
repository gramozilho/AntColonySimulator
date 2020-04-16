extends Node2D

const invade_msg = "Temporary fighting scene"
const explore_msg = "Temporary exploration scene"
const pre_army_numbers_msg = "Number of ants in initial party: "
const pre_territory_msg = "On territory: "

onready var invasion_node = get_node("MarginContainer/MarginContainer/CenterContainer/VBoxContainer/InvasionContainter")
onready var invasion_result = get_node("MarginContainer/MarginContainer/CenterContainer/VBoxContainer/InvasionContainter/Result")
onready var food_found = get_node("MarginContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/NewFood")
onready var ants_gained = get_node("MarginContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer3/NewAnts")
onready var ants_remaining = get_node("MarginContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer2/BackAnts")
onready var top_label = get_node("MarginContainer/MarginContainer/CenterContainer/VBoxContainer/TopLabel")

onready var starting_party = {}
onready var map_pos = WorldVariables.selected_territory

func _ready():
	
	starting_party = WorldVariables.party
	# Label updates
	if WorldVariables.exploration_mode:
		top_label.text = explore_msg
	else:
		top_label.text = invade_msg
	invasion_node.visible = !WorldVariables.exploration_mode
	$MarginContainer/MarginContainer/CenterContainer/VBoxContainer/InputLabel.text = \
		pre_army_numbers_msg + str(WorldVariables.party['ants'])
	$MarginContainer/MarginContainer/CenterContainer/VBoxContainer/TerritoryLabel.text = \
		pre_territory_msg + str(map_pos)
	
	# Party number update
	ants_remaining.value = WorldVariables.party['ants']
	ants_remaining.max_value = WorldVariables.party['ants']


func _on_BaseButton_pressed():
	var loot = {
		"ants": ants_gained.value + ants_remaining.value - starting_party['ants'],
		"food": food_found.value
	}
	if WorldVariables.exploration_mode:
		loot['territory_explored'] = map_pos
	if !WorldVariables.exploration_mode and invasion_result.pressed:
		loot['territory_invaded'] = map_pos
		
	WorldVariables.add_loot(loot)
	print('Temp loot ', loot)
	SceneManager.go_to("map")
