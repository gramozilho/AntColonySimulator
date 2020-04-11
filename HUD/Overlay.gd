extends Area2D

var _is_hovering := false

enum FACTIONS {GREEN, RED, BLUE, YELLOW, PURPLE, BLUEISH}
export(FACTIONS) var faction setget update_faction
const colors = {
	0: Color(.0, .8, .0, 1.0),
	1: Color(.8, .0, .0, 1.0),
	2: Color(.0, .0, .8, 1.0),
	3: Color(.8, .8, .0, 1.0),
	4: Color(.8, .0, .8, 1.0),
	5: Color(.0, .8, .8, 1.0)
}
onready var base_color
onready var off_color
var base_color_unexplored = Color(.8, .8, .8, 1.0)
var off_color_unexplored = Color(.2, .2, .2, 1.0)

var army_size = 0
export(Vector2) var map_pos
signal pressed
var tile_visible = true setget update_visibility
var tile_explored = false setget update_explored
var tile_selectable = true

func _ready():
	faction = randi()%4+1
	update_faction(faction)
	$CollisionPolygon2D/SpriteExplored.modulate = off_color
	$CollisionPolygon2D/SpriteUnexplored.modulate = off_color_unexplored
	$ArmySize.text = "(" + str(map_pos.x) + "," + str(map_pos.y) + ")"
	update_visibility(tile_visible)
	update_explored(tile_explored)

func _on_OverlayCell_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and tile_selectable:
			#print('Tile pressed (local) ', map_pos)
			pressed_animation()
			#emit_signal("tile_pressed", map_pos)
			emit_signal("pressed", map_pos)
			#_is_hovering = false

func highlight(flag):
	if flag:
		$CollisionPolygon2D/SpriteExplored.modulate = base_color
		$CollisionPolygon2D/SpriteUnexplored.modulate = base_color_unexplored
	else:
		$CollisionPolygon2D/SpriteExplored.modulate = off_color
		$CollisionPolygon2D/SpriteUnexplored.modulate = off_color_unexplored

func _on_OverlayCell_mouse_entered() -> void:
	#print('Over tile ', map_pos)
	_is_hovering = true
	if tile_selectable:
		#$CollisionPolygon2D/Sprite.modulate = base_color
		$AnimationPlayer.play("Bob")

func _on_OverlayCell_mouse_exited() -> void:
	_is_hovering = false
	#if tile_selectable:
	#	$CollisionPolygon2D/Sprite.modulate = off_color
		#$AnimationPlayer.play("Reset")


func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if (_is_hovering):
		$AnimationPlayer.play("Bob")
	pass

func pressed_animation():
	$AnimationPlayer.play("Press")


func update_visibility(visibility_flag) -> void:
	tile_visible = visibility_flag
	visible = visibility_flag

func update_explored(explored_flag) -> void:
	tile_explored = explored_flag
	$CollisionPolygon2D/SpriteExplored.visible = explored_flag
	$CollisionPolygon2D/SpriteUnexplored.visible = !explored_flag

func update_faction(faction_idx):
	faction = faction_idx
	base_color = colors[faction]
	off_color = base_color
	off_color[3] = 0.5
	if _is_hovering:
		$CollisionPolygon2D/SpriteExplored.modulate = base_color
	else:
		$CollisionPolygon2D/SpriteExplored.modulate = off_color

func get_faction_name():
	return FACTIONS.keys()[faction]
