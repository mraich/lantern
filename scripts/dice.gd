# script: dice

extends Node2D

var dice_0 = preload("res://res/dice/dice_0.svg")
var dice_1 = preload("res://res/dice/dice_1.svg")
var dice_2 = preload("res://res/dice/dice_2.svg")
var dice_3 = preload("res://res/dice/dice_3.svg")
var dice_4 = preload("res://res/dice/dice_4.svg")
var dice_5 = preload("res://res/dice/dice_5.svg")
var dice_6 = preload("res://res/dice/dice_6.svg")
# This is the old value.
var old_value

# This is our current value.
var value
# This is the face it shows.
var dice_face

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
	dice_face = null

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

	# Determining which state it should show.
	match value:
		1: dice_face = dice_1
		2: dice_face = dice_2
		3: dice_face = dice_3
		4: dice_face = dice_4
		5: dice_face = dice_5
		6: dice_face = dice_6
	pass

func _show_value():
	# Showing the right picture if present.
	if dice_face != null:
		get_node("dice_face").texture = dice_face
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
	roll()
	pass
