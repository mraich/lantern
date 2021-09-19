# script: dice_base

extends Control

var _dice_0 = preload("res://scenes/dice/res/dice_0.svg")
var _dice_1 = preload("res://scenes/dice/res/dice_1.svg")
var _dice_2 = preload("res://scenes/dice/res/dice_2.svg")
var _dice_3 = preload("res://scenes/dice/res/dice_3.svg")
var _dice_4 = preload("res://scenes/dice/res/dice_4.svg")
var _dice_5 = preload("res://scenes/dice/res/dice_5.svg")
var _dice_6 = preload("res://scenes/dice/res/dice_6.svg")
var _dice_7 = preload("res://scenes/dice/res/dice_7.svg")
var _dice_8 = preload("res://scenes/dice/res/dice_8.svg")
var _dice_9 = preload("res://scenes/dice/res/dice_9.svg")

# This is the old value.
var _old_value

# This is our current value.
var _value
# This is the face it shows.
var _dice_face

# Indicating the value has changed.
signal on_value_changed

func _ready():
	_dice_face = null
	_set_value(0)
	pass

# Setting a value.
# This function is the public version of the _set_value function.
func set_value(new_value):
	_set_value(new_value)

	if visible == false:
		visible = true
	pass

# This function is protected which is indicated by the _
# character at the beginning of its signature.
# It might be overridden by the child scenes. In these overridden
# functions this function must be called like ._set_value(value)
# with the . character at the beginning.
func _set_value(new_value):
	_old_value = _value

	_value = new_value

	# Determining which state it should show.
	match _value:
		0: _dice_face = _dice_0
		1: _dice_face = _dice_1
		2: _dice_face = _dice_2
		3: _dice_face = _dice_3
		4: _dice_face = _dice_4
		5: _dice_face = _dice_5
		6: _dice_face = _dice_6
		7: _dice_face = _dice_7
		8: _dice_face = _dice_8
		9: _dice_face = _dice_9

	# Notifying the world that our value has changed.
	emit_signal("on_value_changed", self)

	# Show the value.
	_show_value()
	pass

func _show_value():
	# Showing the right picture if present.
	if _dice_face != null:
		$face_sprite.texture = _dice_face
	pass

func get_value():
	return _value

# Tells the minimum value this dice can show.
func _get_min_value():
	return 1

# Tells the maximum value this dice can show.
func _get_max_value():
	return 6

func get_width():
	return $face_sprite.texture.get_size().x * rect_scale.x

func get_height():
	return $face_sprite.texture.get_size().y * rect_scale.y
