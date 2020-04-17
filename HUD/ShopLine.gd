extends HBoxContainer


export var associated_key_var = 'food' setget update_variable
export var buy_text = "food" setget update_text

onready var variable_reference = ColonyVariables.data[associated_key_var]
#onready var this_script = get_node("NodeWith-script.gd")

func _ready():
	pass

func update_variable(variable):
	variable_reference = ColonyVariables.data[associated_key_var]

func update_text(new_text):
	$Description.text = new_text
