# script: dice_rollable

extends "res://scripts/dice/dice_base.gd"

var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()

	generate_new_value()
	pass

# Generating new value for the dice.
func generate_new_value():
	var new_value = random.randi_range(_get_min_value(), _get_max_value())
	_set_value(new_value)
	pass

# Rolling the dice.
func roll():
	generate_new_value()
	pass
