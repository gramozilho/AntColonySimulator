extends Node

onready var current_scene
var scenes = {'base': "res://Objects/BaseScreen.tscn",
	'map': "res://Objects/WorldMap.tscn"}

func _ready() -> void:
	current_scene = get_tree().current_scene.filename

func go_to(scene_idx) -> void:
	if current_scene != scenes[scene_idx]:
		get_tree().change_scene(scenes[scene_idx])
		current_scene = scenes[scene_idx]
	pass
