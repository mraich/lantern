# script: dice_player

extends "res://scripts/dice/dice_rollable.gd"

# Tells if this dice can be flipped.
var is_flippable

func _ready():
	set_flippable(true)
	pass

func set_flippable(is_flippable):
	self.is_flippable = is_flippable
	pass

func flip():
	if is_flippable:
		var new_value = _MAX + _MIN - _value
		_set_value(new_value)
	pass
