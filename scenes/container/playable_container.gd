# script: puzzle_container

extends "res://scenes/container/dice_container.gd"

var playable_class = preload("res://scenes/dice/dice_playable.tscn")

# We will temporarily disable emitting on_value_changed signals.
var _on_data_change_signal_enabled = true

func _ready():
	init(playable_class)

	# Rolling every dice for stats.
	# There are 6 stats we have to arrange.
	set_dice_count(6)
	roll_all()
	pass

func set_dice_action(action):
	for dice in dices:
		dice.set_action(action)
	pass

# By overriding this function of the dice_container we can disable the signal temporarily.
func _on_dice_value_changed(var dice):
	if _on_data_change_signal_enabled:
		._on_dice_value_changed(dice)
	pass

# Rolling all of the dices.
func roll_all():
	_on_data_change_signal_enabled = false

	for dice in dices:
		dice.roll()
		dice. visible = true

	_on_data_change_signal_enabled = true
	emit_signal("on_value_changed")
	pass

# Rolling all of the dices which were selected for rolling.
func roll_multiple():
	_on_data_change_signal_enabled = false

	for dice in dices:
		dice.roll_multiple()

	_on_data_change_signal_enabled = true
	emit_signal("on_value_changed")
	pass

func _add_dice():
	# Calling the add_dice function of the base class
	._add_dice()

	# Updating input actions.
	# It's not too efficient to iterate over all of the dices
	# every time we add a dice but it works every time.
	# And it's not the time for optimalization yet.
	var i = 0
	for dice in dices:
		dice.set_input_action("ui_playable_dice_clicked_" + str(i))
		i += 1
	pass
