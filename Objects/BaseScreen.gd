extends Control


onready var error_msg_node = get_node("Interface/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/ErrorMsg")


func _on_MoreFood_pressed() -> void:
	ColonyVariables.update_data('food', 5)


func _on_UpgradeFood_pressed() -> void:
	button_press_feedback(ColonyVariables.update_data('max_food'))


func _on_MoreAnts_pressed() -> void:
	button_press_feedback(ColonyVariables.update_data('ants'))


func _on_UpgradeAnts_pressed() -> void:
	button_press_feedback(ColonyVariables.update_data('max_ants'))


func _on_BaseButton_pressed():
	SceneManager.go_to("map")


func button_press_feedback(string):
	error_msg_node.text = string
	error_msg_node.get_node("Shake").shake()
