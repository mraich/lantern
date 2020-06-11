#script: puzzle

extends "res://scripts/dice/dice_base.gd"

var _dice_x = preload("res://res/dice/dice_x.svg")
var _dice_x_2 = preload("res://res/dice/dice_x_2.svg")

func _ready():
	_set_value("x")
	pass

func _set_value(new_value):
	# Determining which state it should show.
	# These values differ from the ones determined in the
	# base class.
	match new_value:
		"x": _dice_face = _dice_x
		"x_2": _dice_face = _dice_x_2

	# Calling the base _set_value fuction.
	# It will set the value of the _value variable.
	._set_value(new_value)

	_show_value()
	pass
