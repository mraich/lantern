# script: dice_rollable

extends "res://scripts/dice/dice_base.gd"

# These are the minimal and maximal possible values.
const _MIN = 1
const _MAX = 6

func _ready():
	randomize()

	generate_new_value()
	pass

# Generating new value for the dice.
func generate_new_value():
	_set_value(randi() % _MAX + _MIN)
	pass

# Rolling the dice.
func roll():
	generate_new_value()
	pass
