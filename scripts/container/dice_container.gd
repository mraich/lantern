#script: dice_container

extends HBoxContainer

var dices = []

# Indicating the value has changed.
signal on_value_changed

func _ready():
	pass

func init(dice_class, dice_count):
	var next_position = 0
	for n in range(0, dice_count):
		var dice = dice_class.instance()
		dice.position = Vector2(next_position, dice.get_height())
		next_position += dice.get_width()
		dices.push_back(dice)

		# Passing through events.
		# Passing through the signal for a dice value changing.
		dice.connect("on_value_changed", self, "_on_dice_value_changed")

		add_child(dice)

	# Correcting the position of the dices to have them
	# to be arranged in the center of the given position
	# for the DiceContainer.
	var offsetX = -(next_position - next_position / dice_count) / 2
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
