#script: dice_container

extends HBoxContainer

var dices = []
var _dice_class

# Indicating the value has changed.
signal on_value_changed

func _ready():
	pass

func init(dice_class, dice_count):
	_dice_class = dice_class
	for n in range(0, dice_count):
		_add_dice()
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
