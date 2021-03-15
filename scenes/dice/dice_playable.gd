# script: dice_playable

extends "res://scenes/dice/dice_clickable.gd"

const ACTION_NOTHING = 0
const ACTION_ROLL = 1
const ACTION_FLIP = 2
const ACTION_INC = 3
const ACTION_DEC = 4
# These two states are alternating by clicking on a dice.
# Rolling with multiple dices switched off.
const ACTION_ROLL_MULTIPLE_OFF = 5
# Rolling with multiple dicesswitched on.
# This state will be reached only by clicking on a dice at the state ACTION_ROLL_MULTIPLE_OFF.
const ACTION_ROLL_MULTIPLE_ON = -1
var _action = ACTION_NOTHING

func _ready():
	set_action(ACTION_NOTHING)
	pass

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
		ACTION_ROLL_MULTIPLE_OFF:
			set_action(ACTION_ROLL_MULTIPLE_ON)
		ACTION_ROLL_MULTIPLE_ON:
			set_action(ACTION_ROLL_MULTIPLE_OFF)
	pass

func set_action(action):
	_action = action

	# We show that this dice is selected.
	if not _action == ACTION_ROLL_MULTIPLE_ON:
		$selected_sprite.visible = false
	else:
		$selected_sprite.visible = true
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

# Called from outside when it is rolled with multiple dices.
func roll_multiple():
	if _action == ACTION_ROLL_MULTIPLE_ON:
		# Multi roll state switches off.
		set_action(ACTION_ROLL_MULTIPLE_OFF)
		# The dice gets a new random value.
		roll()
	pass
