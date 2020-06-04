# script: dice

extends Node2D

# This is the old value.
var old_value

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

# This is an offset for the values 1, 2, and 3.
# The sprite is not ideal so we have to adjust a little the y position in these case.
var _display_offset = Vector2(0, 3)

func _ready():
	get_node("dice_area").connect("on_dice_clicked", self, "_on_dice_clicked")

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
	old_value = value

	value = new_value
	pass

func _show_value():
	get_node("dice_face").frame = value - 1

	# Adjusting the position due to the sprite.
	match old_value:
		null, 1, 2, 3:
			match value:
				4, 5, 6:
					#self.position.y -= 3
					position -= _display_offset
		4, 5, 6:
			match value:
				1, 2, 3:
					position += _display_offset
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

func _on_dice_clicked():
	# This function is called when someone clicks on the dice.
	pass
