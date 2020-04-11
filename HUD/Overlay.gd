extends Area2D

var _is_hovering := false
#export var base_color := Color(1.0, 1.0, 1.0, 1.0)
onready var base_color
onready var off_color 

enum FACTIONS {GREEN, RED, BLUE}
export(FACTIONS) var faction
const colors = {
	0: Color(.0, .8, .0, 1.0),
	1: Color(.8, .0, .0, 1.0),
	2: Color(.0, .0, .8, 1.0)
}

var army_size = 0
export(Vector2) var map_pos

func _ready():
	base_color = colors[faction]
	off_color = base_color
	off_color[3] = 0.5
	$CollisionPolygon2D/Sprite.modulate = off_color
	$ArmySize.text = "(" + str(map_pos.x) + "," + str(map_pos.y) + ")"


func _on_OverlayCell_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			$AnimationPlayer.play("Press")
			_is_hovering = false

func _on_OverlayCell_mouse_entered() -> void:
	print('!')
	_is_hovering = true
	$CollisionPolygon2D/Sprite.modulate = base_color
	#$AnimationPlayer.play("Bob")


func _on_OverlayCell_mouse_exited() -> void:
	_is_hovering = false
	$CollisionPolygon2D/Sprite.modulate = off_color
	#$AnimationPlayer.stop()


func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if (_is_hovering):
		$AnimationPlayer.play("Bob")
	pass
