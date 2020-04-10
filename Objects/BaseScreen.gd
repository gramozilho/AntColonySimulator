extends Control

signal buy

func _on_MoreFood_pressed() -> void:
	ColonyManager.food = 5

func _on_UpgradeFood_pressed() -> void:
	if ColonyManager.buy_inquire('max_food'):
		ColonyManager.max_food = ColonyManager.max_food + 10
	pass


func _on_MoreAnts_pressed() -> void:
	if ColonyManager.buy_inquire('ants'):
		ColonyManager.ants = 5
	pass


func _on_UpgradeAnts_pressed() -> void:
	if ColonyManager.buy_inquire('ants'):
		ColonyManager.max_ants = ColonyManager.max_ants + 10
	pass

