# script: dice

extends Node2D

# This is our current value.
var value

# These are the minimal and maximal possible values.
const MIN = 1
const MAX = 6

# Indicating the value has changed.
signal on_value_changed
const VALUE_CHANGED_BY_ROLL = 0
const VALUE_CHANGED_BY_ABILITY = 1


func _ready():
	randomize()

	generate_new_value()
	pass

# Generating new value for the dice.
func generate_new_value():
	value = randi() % MAX + MIN
	pass

# Rolling the dice.
func roll():
	generate_new_value()

	emit_signal("on_value_changed", self, VALUE_CHANGED_BY_ROLL)
	pass

# Critical hit.
# Turns the dice upside down.
func critical_hit():
	value = MIN + MAX - value

	# Indicating the value is changed.
	# We will have to evaluate the scene.
	emit_signal("on_value_changed", self, VALUE_CHANGED_BY_ABILITY)
	pass
