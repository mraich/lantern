#script: dice_container

extends HBoxContainer

var dices = []
const _DICE_COUNT = 6
const _dice_class = preload("res://scenes/dice/dice_player.tscn")

# Indicating the value has changed.
signal on_value_changed

# Indicating the all dice function is called.
signal on_all_dices_rolled

func _ready():
	for n in range(0, _DICE_COUNT):
		var dice = _dice_class.instance()
		dice.position = Vector2(n * dice.get_width(), dice.get_height())
		dices.push_back(dice)

		# Passing through events.
		# Passing through the signal for a dice value changing.
		dice.connect("on_value_changed", self, "_on_dice_value_changed")

		add_child(dice)
	pass

func _on_dice_value_changed(var dice):
	# Listeners will know that this dice value has been changed.
	emit_signal("on_value_changed", dice)
	pass

# Rolling all dices at once.
func roll_all():
	for dice in dices:
		dice.roll()

	# Notifying the outside world that the function is completed.
	emit_signal("on_all_dices_rolled")
	pass
