extends Node

var food = 5 setget update_food
var max_food = 10 setget update_max_food
var ants = 10 setget update_ants
var max_ants = 20 setget update_max_ants

var prices = {'ants': 1, 'max_ants':1, 'max_food': 1}

func _ready() -> void:
	update_hud()

func update_food(change) -> void:
	food = min(food + change, max_food)
	update_hud()
	
func update_max_food(new_value) -> void:
	max_food += new_value
	update_hud()
	
func update_ants(change) -> void:
	ants = min(ants + change, max_ants)
	update_hud()
	
func update_max_ants(new_value) -> void:
	max_ants += new_value
	update_hud()

func update_hud() -> void:
	$VBoxContainer/Food.text = "Food: " + str(food) + "/" + str(max_food)
	$VBoxContainer/Ants.text = "Ants: " + str(ants) + "/" + str(max_ants)


func _on_LoadBase_pressed() -> void:
	SceneManager.go_to("base")

func _on_LoadMap_pressed() -> void:
	SceneManager.go_to("map")

func buy_inquire(key) -> bool:
	# For shop use. If food amount can be subtracted, do so and return true.
	if food >= prices[key]:  # If there is enough food for this purchase
		food -= prices[key]
		return true
	return false


