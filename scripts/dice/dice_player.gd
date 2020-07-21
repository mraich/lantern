# script: dice_player

extends "res://scripts/dice/dice_rollable.gd"

# Tells if this dice can be flipped.
var is_flippable

# Tells if this dice can be rolled.
var is_rollable

func _ready():
	set_flippable(true)
	set_rollable(true)
	pass

func set_flippable(is_flippable):
	self.is_flippable = is_flippable
	pass

func set_rollable(is_rollable):
	self.is_rollable = is_rollable
	pass

func flip():
	if is_flippable:
		var new_value = _MAX + _MIN - _value
		_set_value(new_value)
	pass

func roll():
	if is_rollable:
		.roll()
	pass
