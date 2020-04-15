extends Node2D

onready var shortcuts_x = 1550
onready var shortcuts_off = 0
const shortcuts_on = 0
onready var offset_path = get_node("MarginContainer/MarginContainer/CenterContainer/VBoxContainer/ToggleShortcuts/ShortcutsOffset")

func _ready():
	shortcuts_x = global_position.x
	shortcuts_off = -offset_path.global_position.y
	position = Vector2(shortcuts_x, shortcuts_off)

func _input(event) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _on_ToggleShortcuts_pressed() -> void:
	var shortcuts_y
	if position.y == shortcuts_off:
		shortcuts_y = shortcuts_on
	else:
		shortcuts_y = shortcuts_off
	$Tween.interpolate_property(self, "position:y", position.y, \
		shortcuts_y, .4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

func _on_LoadBase_pressed() -> void:
	SceneManager.go_to("base")

func _on_LoadMap_pressed() -> void:
	SceneManager.go_to("map")

func _on_ExtraFood_pressed():
	ColonyVariables.cheatcode('food')
