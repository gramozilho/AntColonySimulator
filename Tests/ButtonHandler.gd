extends Node2D

const HexagonTile = preload("res://HUD/Overlay.tscn")

func _ready():
	for x in range(20):
	#var new_button = Button.new()
		var new_button = HexagonTile.instance()
		new_button.position = Vector2( x*100, 0)
		new_button.map_pos = Vector2(x, 0)
		new_button.connect("pressed", self, "_button_pressed")
		new_button.connect("pressed", get_parent(), "_button_pressed")
		add_child(new_button)

func _button_pressed(aa):
	print('Button pressed from handler', aa)
