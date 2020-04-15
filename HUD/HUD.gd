extends CanvasLayer


func update(data):
	$VBoxContainer/Food.text = "Food: " + str(data['food']) + "/" + str(data['max_food'])
	$VBoxContainer/Ants.text = "Ants: " + str(data['ants']) + "/" + str(data['max_ants'])
