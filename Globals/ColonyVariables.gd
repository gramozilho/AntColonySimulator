extends Node

var data2 = {
	'food': 5,
	'max_food': 10,
	'ants': 10,
	'max_ants': 20
}

var data = {
	'food': {'value': 10},
	'max_food': {
		'value': 10, 
		'buy': {'amount': 10, 'cost': [1, 2, 3, 4, 5], 'idx': 0, 'max': false}},
	'ants': {
		'value': 10,
		'buy': {'amount': 5, 'cost': [5], 'idx': 0, 'max': false}},
	'max_ants': {
		'value': 20, 
		'buy': {'amount': 10, 'cost': [1, 2, 3], 'idx': 0, 'max': true}},
	}
 
var food = 5 setget update_food
var max_food = 10 setget update_max_food
var ants = 10 setget update_ants
var max_ants = 20 setget update_max_ants

var prices = {'ants': 1, 'max_ants':1, 'max_food': 1}

func _ready() -> void:
	update_hud()

#func update_data(info) -> bool:
func update_data(key, value=0, replace_value=false) -> String:
	# Expects 3 parameters: 
	#	KEY (which var to change)
	#	VALUE (to use in operation below)
	#	REPLACE_VALUE (bool, if true sums value with current, false replaces)
	# Returns EMPTY STRING if sucess or ERROR STRING if not 
	var current_food = data['food']['value']
	
	# Check there is enough money for action
	if "buy" in data[key]:
		# Use predefined buy amount if 0 given
		if value == 0:
			value = data[key]['buy']['amount']
		# Check if not alreay at maximum
		var buy_idx = data[key]['buy']['idx']
		var buy_maximum = data[key]['buy']['max']
		var number_of_buys = len(data[key]['buy']['cost'])
		
		if (buy_idx >= (number_of_buys-1)) and buy_maximum:
			# Already maxed this purchase
			return "Can't buy more"

		var cost = data[key]['buy']['cost'][buy_idx]
		var wallet = data['food']['value']
		
		if wallet - cost >= 0:
			# If there is enough money remove paid food
			data['food']['value'] -= cost
			# And update new limits
			if buy_idx < (number_of_buys-1):
				data[key]['buy']['idx'] += 1
		else:
			return "Not enough food"
	
	# Take action
	data[key]['value'] = data[key]['value']*float(!replace_value) + value
	
	# Clip value
	data[key]['value'] = max(data[key]['value'], 0)
	if ('max_' + key) in data:  # If there is a max defined for this variable
		data[key]['value'] = min(data[key]['value'], data['max_' + key]['value'])
	
	# Update displays
	update_hud()
	return ""

func save():
	return data

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
	var hud_data = {}
	for variable in ['ants', 'max_ants', 'food', 'max_food']:
		hud_data[variable] = data[variable]['value']
	print(hud_data)
	for hud in get_tree().get_nodes_in_group("hud"):
		hud.update(hud_data)
	pass

func buy_inquire(key) -> bool:
	# For shop use. If food amount can be subtracted, do so and return true.
	if food >= prices[key]:  # If there is enough food for this purchase
		food -= prices[key]
		return true
	return false

func cheatcode(code):
	update_data('food', 50)
	#if code == 'food':
		#data['food']['value'] += 50
		#update_hud()
		#self.food += 50

func change_variable(var_name, change):
	if var_name == "food":
		pass #update_food()

func add_loot(loot):
	update_ants(loot['ants'])
	update_food(food + loot['food'])
