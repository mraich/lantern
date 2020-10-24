# script: dice_playable

extends "res://scripts/dice/dice_clickable.gd"

const ACTION_NOTHING = 0
const ACTION_ROLL = 1
const ACTION_FLIP = 2
const ACTION_INC = 3
const ACTION_DEC = 4
var _action = ACTION_NOTHING

func _on_dice_clicked():
	# This function is called when someone clicks on the dice.
	match _action:
		ACTION_ROLL:
			roll()
		ACTION_FLIP:
			flip()
		ACTION_INC:
			inc()
		ACTION_DEC:
			dec()
	pass

func set_action(action):
	_action = action
	pass

func inc():
	_alter(1)
	pass

func dec():
	_alter(-1)
	pass

func _alter(alter_by):
	var new_value = _value + alter_by
	if new_value >= _get_min_value() and new_value <= _get_max_value():
		_set_value(new_value)
	pass

func flip():
	var new_value = _get_max_value() + _get_min_value() - _value
	_set_value(new_value)
	pass
