#script: dice_container

extends HBoxContainer

var dices = []
const _DICE_COUNT = 6
const _dice_class = preload("res://scenes/dice/dice_playable.tscn")

# Indicating the value has changed.
signal on_value_changed

func _ready():
	var next_position = 0
	for n in range(0, _DICE_COUNT):
		var dice = _dice_class.instance()
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
	var offsetX = -(next_position - next_position / _DICE_COUNT) / 2
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
