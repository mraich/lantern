# script: dice_playable

extends "res://scripts/dice/dice_rollable.gd"

func _ready():
	# Setting signal for recognize clicking on the dice area.
	get_node("dice_area").connect("on_dice_drag_starts", self, "_on_dice_drag_starts")
	get_node("dice_area").connect("on_dice_drag_ends", self, "_on_dice_drag_ends")
	pass

func _on_dice_drag_starts():
	print("drag starts")
	pass

func _on_dice_drag_ends():
	print("drag ends")
	pass

func inc():
	_alter(1)
	pass

func dec():
	_alter(-1)
	pass

func _alter(alter_by):
	var new_value = _value + alter_by
	if new_value >= _get_min_value() and new_value <= _get_max_value():
		_set_value(new_value)
		pass
	pass

func flip():
	var new_value = _get_max_value() + _get_min_value() - _value
	_set_value(new_value)
	pass
