#script: puzzle

extends Node2D

enum FACES {
  NONE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, X, X_2
}

var _dice_0 = preload("res://res/dice/dice_0.svg")
var _dice_1 = preload("res://res/dice/dice_1.svg")
var _dice_2 = preload("res://res/dice/dice_2.svg")
var _dice_3 = preload("res://res/dice/dice_3.svg")
var _dice_4 = preload("res://res/dice/dice_4.svg")
var _dice_5 = preload("res://res/dice/dice_5.svg")
var _dice_6 = preload("res://res/dice/dice_6.svg")
var _dice_7 = preload("res://res/dice/dice_7.svg")
var _dice_8 = preload("res://res/dice/dice_8.svg")
var _dice_9 = preload("res://res/dice/dice_9.svg")
var _dice_x = preload("res://res/dice/dice_x.svg")
var _dice_x_2 = preload("res://res/dice/dice_x_2.svg")

# This is our current value.
var value
# This is the face it shows.
var _dice_face

func _ready():
	_set_value(0)
	pass

func get_width():
	return 50
	pass

func get_height():
	return 50
	pass

func _set_value(new_value):
	value = new_value

	# Determining which state it should show.
	match value:
		1: _dice_face = _dice_1
		2: _dice_face = _dice_2
		3: _dice_face = _dice_3
		4: _dice_face = _dice_4
		5: _dice_face = _dice_5
		6: _dice_face = _dice_6
		7: _dice_face = _dice_7
		8: _dice_face = _dice_8
		9: _dice_face = _dice_9
		"x": _dice_face = _dice_x
		"x_2": _dice_face = _dice_x_2

	_show_value()
	pass

func _show_value():
	# Showing the right picture if present.
	if _dice_face != null:
		get_node("puzzle_face").texture = _dice_face
	pass
