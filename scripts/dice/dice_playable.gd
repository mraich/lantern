# script: dice_playable

extends "res://scripts/dice/dice_rollable.gd"

var t_draggable = preload("res://scripts/resource/draggable.gd")
var draggable = t_draggable.new()

func _ready():
	draggable.set_draggable_body(self)
	pass

func _input_event(viewport, event, shape_idx):
	draggable._input_event(viewport, event, shape_idx)
	pass

func _process(delta):
	draggable._process(delta)
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
