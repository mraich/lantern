#script: dice_container

extends HBoxContainer

var t_z_index = preload("res://scripts/resource/z_index.gd")
var z_index = t_z_index.new()

var dices = []
const _DICE_COUNT = 6
const _dice_class = preload("res://scenes/dice/dice_playable.tscn")

# Indicating the value has changed.
signal on_value_changed

# Indicating the all dice function is called.
signal on_all_dices_rolled

func _ready():
	for n in range(0, _DICE_COUNT):
		var dice = _dice_class.instance()
		dice.position = Vector2(n * dice.get_width(), dice.get_height())
		dices.push_back(dice)

		# Dragging of the dice.
		dice.connect("on_drag_begin", self, "_on_drag_begin")

		# Passing through events.
		# Passing through the signal for a dice value changing.
		dice.connect("on_value_changed", self, "_on_dice_value_changed")

		add_child(dice)

	# These are the objects we want to maintain z index.
	z_index._set_objects(dices)
	pass

# Dragging of the dice.
func _on_drag_begin(dice):
	# Change the z index to max for the dice we are dragging.
	z_index._change_z_index_to_max(dice)
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
