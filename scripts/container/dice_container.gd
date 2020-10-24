#script: dice_container

extends HBoxContainer

var dices = []
var _dice_class

# Indicating the value has changed.
signal on_value_changed

func _ready():
	pass

func init(dice_class):
	_dice_class = dice_class
	pass

# Setting arrangement.
# Layout is an array of the values to be shown on each particular dice.
func set_arrangement(arrangement):
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

# Removing the first dice from the control.
func _pop_dice():
	if dices.size() > 0:
		remove_child(dices[0])
		dices.pop_front()

	_update_dices_position()
	pass

func _add_dice():
	var dice = _dice_class.instance()
	dices.push_back(dice)

	# Passing through events.
	# Passing through the signal for a dice value changing.
	dice.connect("on_value_changed", self, "_on_dice_value_changed")

	add_child(dice)

	_update_dices_position()
	pass

# Correcting the position of the dices to have them
# to be arranged in the center of the given position
# for the DiceContainer.
func _update_dices_position():
	var i = 0
	for dice in dices:
		dice.position = Vector2(i * dice.get_width(), dice.get_height())
		i += 1

	var offsetX = 0
	if dices.size() > 0:
		offsetX = -(dices.size() - 1) * dices[0].get_width() / 2
	for dice in dices:
		dice.position.x += offsetX
	pass

func _on_dice_value_changed(var dice):
	# Listeners will know that this dice value has been changed.
	emit_signal("on_value_changed", dice)
	pass

func set_dice_action(action):
	for dice in dices:
		dice.set_action(action)
		pass
	pass

# Getting the values of all of the dices in an array.
func get_values():
	var dice_values = []
	for dice in dices:
		dice_values.push_back(dice.get_value())
		pass
	return dice_values
	pass
