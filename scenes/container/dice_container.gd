# script: dice_container

extends Control

var dices = []
var _dice_class

export(int) var dice_count = 0 setget set_dice_count

# This is the arrangement needs to be loaded later.
# It won't change the arrangement shown until the load_arrangement function called.
var arrangement = []

# Indicating the value has changed.
signal on_value_changed

# Indicating that a dice is prepared.
signal on_prepared

func _ready():
	pass

func init(dice_class):
	_dice_class = dice_class
	pass

# Setting the arrangement.
# It will be loaded by the load_arrangement function.
func set_arrangement(new_arrangement):
	arrangement = new_arrangement
	$animation.play("load_arrangement")
	pass

# Setting arrangement.
# Layout is an array of the values to be shown on each particular dice.
func load_arrangement():
	# Ensuring there will be enough dices for the layout.
	_ensure_dice_count(arrangement.size())

	# Setting arrangement values to each particular dices.
	var i = 0
	for dice in dices:
		dice._set_value(arrangement[i])
		i += 1
	pass

func set_dice_count(count):
	_ensure_dice_count(count)
	pass

func _ensure_dice_count(count):
	# In case there are less dices then value of count then this loop will add as many dices as needed.
	for n in range(dices.size(), count):
		_add_dice()
	# In case there are more dices then value of count then this loop will remove as many dices as not needed.
	for n in range(count, dices.size()):
		_pop_dice()
	pass

# Adding dice to the end of the list.
# This dice is added to the tree of this control.
func _add_dice():
	var dice = _dice_class.instance()
	dice.rect_scale = rect_scale
	dices.push_back(dice)
	add_child(dice)

	# Update the position of the dices.
	_update_dices_position()

	# Passing through events.
	# Passing through the signal for a dice value changing.
	dice.connect("on_value_changed", self, "_on_dice_value_changed")
	# Passing through the prepare event.
	dice.connect("on_prepared", self, "_on_prepared")
	pass

# Removing the first dice from the control.
func _pop_dice():
	if dices.size() > 0:
		remove_child(dices[0])
		dices.pop_front()

	# Update the position of the dices.
	_update_dices_position()
	pass

# Correcting the position of the dices to have them
# to be arranged in the center of the given position
# for the DiceContainer.
func _update_dices_position():
	var i = 0
	for dice in dices:
		dice.rect_position = Vector2(i * dice.get_width() * 1.2, dice.get_height())
		i += 1

	var offsetX = 0
	if dices.size() > 0:
		offsetX = -(dices.size() - 0) * dices[0].get_width() / 2
	for dice in dices:
		dice.rect_position.x += offsetX
		# dice.rect_position += rect_position
	pass

func _on_dice_value_changed(var dice):
	# Listeners will know that this dice value has been changed.
	emit_signal("on_value_changed", dice)
	pass

func _on_prepared(var dice):
	# Listeners will know that the prepare action clicked.
	emit_signal("on_prepared", dice)
	pass

func on_unprepared(var dice):
	dice.unprepare()
	pass

# Getting the values of all of the dices in an array.
func get_values():
	var dice_values = []
	for dice in dices:
		dice_values.push_back(dice.get_value())
	return dice_values
