extends Node

onready var current_scene
var scenes = {'base': "res://Objects/BaseScreen.tscn",
	'map': "res://Objects/WorldMap.tscn"}
const SaveGame = preload("res://Save/SaveGame.gd")
var game_data = {}

func _ready() -> void:
	current_scene = get_tree().current_scene.filename

func go_to(scene_idx) -> void:
	if current_scene != scenes[scene_idx]:
		var _changed_scene = get_tree().change_scene(scenes[scene_idx])
		current_scene = scenes[scene_idx]
	pass

func save_game() -> void:
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		game_data[i.name] = i.save()
	
	# Write to file

func load_game():
	# Load file
	
	# Update info
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		game_data[i.name] = i.save()
