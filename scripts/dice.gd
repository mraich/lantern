# script: dice

extends Node2D

# This is our current value.
var value

# These are the minimal and maximal possible values.
const MIN = 1
const MAX = 6

# Indicating the value has changed by rolling.
signal on_value_changed_by_roll

func _ready():
	randomize()

	roll()
	pass

# Generating new value for the dice.
func generate_new_value():
	value = randi() % MAX + MIN
	pass

# Rolling the dice.
func roll():
	generate_new_value()

	emit_signal("on_value_changed_by_roll", self)
	pass
