# script: dice_playable

extends "res://scripts/dice/dice_rollable.gd"

# Tells if this dice can be flipped.
var is_flippable

# Tells if this dice can be rolled.
var is_rollable

# Tells if this dice can be alterable.
# Altering means we can increase or decrease the value by 1.
var is_alterable

func _ready():
	set_alterable(true)
	set_flippable(true)
	set_rollable(true)
	pass

func set_alterable(is_alterable):
	self.is_alterable = is_alterable
	pass

func set_flippable(is_flippable):
	self.is_flippable = is_flippable
	pass

func set_rollable(is_rollable):
	self.is_rollable = is_rollable
	pass

func inc():
	_alter(1)
	pass

func dec():
	_alter(-1)
	pass

func _alter(alter_by):
	if is_alterable:
		var new_value = _value + alter_by
		if new_value >= _get_min_value() and new_value <= _get_max_value():
			_set_value(new_value)
			pass
		pass
	pass

func flip():
	if is_flippable:
		var new_value = _get_max_value() + _get_min_value() - _value
		_set_value(new_value)
	pass

func roll():
	if is_rollable:
		.roll()
	pass
