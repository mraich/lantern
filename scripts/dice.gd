# script: dice

extends Node2D

# This is our current value.
var value

# These are the minimal and maximal possible values.
const MIN = 1
const MAX = 6

# Indicating the value has changed.
signal on_value_changed

# Indicating the flip function is called.
signal on_flip

# Indicating the plus or minus function is called.
signal on_plus_minus

func _ready():
	randomize()

	generate_new_value()
	pass

func get_width():
	return 50
	pass

func get_height():
	return 50
	pass

# Rolling the dice.
func roll():
	generate_new_value()

	emit_signal("on_value_changed", self)
	pass

# Generating new value for the dice.
func generate_new_value():
	_set_value(randi() % MAX + MIN)

	_show_value()
	pass

func _set_value(new_value):
	value = new_value
	pass

func _show_value():
	get_node("dice_face").frame = value - 1
	pass

# Flipping the dice.
# Turns the dice upside down.
func flip():
	_set_value(MIN + MAX - value)
	_show_value()

	# There was a flip occcured.
	emit_signal("on_flip")

	# Indicating the value is changed.
	# We will have to evaluate the scene.
	emit_signal("on_value_changed", self)
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
func plus():
	_change_value(1)
	pass

# Counter attack for subtracking a value.
func minus():
	_change_value(-1)
	pass

# Private function to realize change the value
# in the general case.
# Adds or subtracts a value.
# The value MAX cannot change into MIN as
# the value MIN cannot change into MAX.
func _change_value(offset):
	_set_value(value + offset)

	# Checking the values.
	if value < MIN:
		value = MIN
		_show_value()
		return
		pass

	if value > MAX:
		value = MAX
		_show_value()
		return
		pass

	# There was a change value called.
	emit_signal("on_plus_minus")

	# Indicating the value is changed.
	# We will have to evaluate the scene.
	emit_signal("on_value_changed", self)
	pass
