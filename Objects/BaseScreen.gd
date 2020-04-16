extends Control


func _on_MoreFood_pressed() -> void:
	ColonyVariables.food = 5

func _on_UpgradeFood_pressed() -> void:
	if ColonyVariables.buy_inquire('max_food'):
		ColonyVariables.max_food = ColonyVariables.max_food + 10
	pass


func _on_MoreAnts_pressed() -> void:
	if ColonyVariables.buy_inquire('ants'):
		ColonyVariables.ants = 5
	pass


func _on_UpgradeAnts_pressed() -> void:
	if ColonyVariables.buy_inquire('ants'):
		ColonyVariables.max_ants = ColonyVariables.max_ants + 10
	pass


func _on_BaseButton_pressed():
	SceneManager.go_to("map")
