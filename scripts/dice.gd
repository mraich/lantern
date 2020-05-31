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

# Indicating the critical hit function was called.
signal on_critical_hit

# Indicating the counter attach function was called.
signal on_counter_attack

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

	# There was a critical hit occcured.
	# We will decrease the amount of possible future critical
	# hits count.
	emit_signal("on_critical_hit")

	# Indicating the value is changed.
	# We will have to evaluate the scene.
	emit_signal("on_value_changed", self, VALUE_CHANGED_BY_ABILITY)
	pass

# Indicating the value is the lowest possible value.
func is_min():
	return value == MIN
	pass

# Indicating the value is the highest possible value.
func is_max():
	return value == MAX
	pass

# Counter attack for adding a value.
func counter_attack_plus():
	_counter_attack_internal(1)
	pass

# Counter attack for subtracking a value.
func counter_attack_minus():
	_counter_attack_internal(-1)
	pass

# Private functuon to realize counter attack
# in the general case.
# Counter attack adds or subtracts a value.
# The value MAX cannot change into MIN as
# the value MIN cannot change into MAX.
func _counter_attack_internal(offset):
	value += offset

	# Checking the values.
	if value < MIN:
		value = MIN
		return
		pass

	if value > MAX:
		value = MAX
		return
		pass

	# There was a counter attack occcured.
	# We will decrease the amount of possible future counter
	# attacks count.
	emit_signal("on_counter_attack")

	# Indicating the value is changed.
	# We will have to evaluate the scene.
	emit_signal("on_value_changed", self, VALUE_CHANGED_BY_ABILITY)
	pass
