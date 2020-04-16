extends Tween

func shake():
	var parent = get_parent()
	var pos = get_parent().margin_left
	print(parent, ' is parent, pos is ', pos)
	interpolate_property(parent, "margin_left", \
		pos+(50+100*randf()), pos, .6, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	start()
	print('shake')
