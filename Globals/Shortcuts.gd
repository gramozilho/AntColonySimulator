extends Node


func _input(event) -> void:
	
	if event.is_action_pressed("escape"):
		get_tree().quit()
