extends Button

var _is_hovering := false

func _ready():
	$AnimationPlayer.play("Reset")

func _on_BaseButton_mouse_entered() -> void:
	if !disabled:
		_is_hovering = true
		#modulate = Color(1.5, 1.5, 1.5, 1)
		$AnimationPlayer.play("Bob")
		$HoverSound.play()
	pass

func _on_BaseButton_mouse_exited() -> void:
	if !disabled:
		_is_hovering = false
		#modulate = Color(1, 1, 1, 1)
		$AnimationPlayer.play("Reset")
		rect_scale = Vector2.ONE
	pass

func _on_BaseButton_pressed() -> void:
	if !disabled:
		$AnimationPlayer.play("Press")
	pass

func _on_AnimationPlayer_animation_finished(_anim_name : String) -> void:
	if (_is_hovering) and !disabled:
		$AnimationPlayer.play("Bob")
	pass

func lock_pressed():
	$AnimationPlayer.play("LockPressed")
	disabled = true

func release():
	$AnimationPlayer.play("Reset")
	disabled = false
