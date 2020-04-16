extends Node

var food = 5 setget update_food
var max_food = 10 setget update_max_food
var ants = 10 setget update_ants
var max_ants = 20 setget update_max_ants

var prices = {'ants': 1, 'max_ants':1, 'max_food': 1}

func _ready() -> void:
	update_hud()

func update_food(new_food) -> void:
	food = min(new_food, max_food)
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
	for hud in get_tree().get_nodes_in_group("hud"):
		hud.update({
			'ants': ants, 'max_ants': max_ants, \
			'food': food, 'max_food': max_food})
	#$VBoxContainer/Food.text = "Food: " + str(food) + "/" + str(max_food)
	#$VBoxContainer/Ants.text = "Ants: " + str(ants) + "/" + str(max_ants)
	pass

func buy_inquire(key) -> bool:
	# For shop use. If food amount can be subtracted, do so and return true.
	if food >= prices[key]:  # If there is enough food for this purchase
		food -= prices[key]
		return true
	return false

func cheatcode(code):
	if code == 'food':
		self.food += 50

func change_variable(var_name, change):
	if var_name == "food":
		pass #update_food()

func add_loot(loot):
	update_ants(loot['ants'])
	update_food(food + loot['food'])
