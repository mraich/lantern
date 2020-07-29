# script: dice_playable

extends "res://scripts/dice/dice_rollable.gd"

var _draggable = globals.draggable.new()

signal on_drag_begin
signal on_drag_end

func _ready():
	_draggable.set_draggable_body(self)
	_draggable.connect("on_drag_begin", self, "_on_drag_begin")
	_draggable.connect("on_drag_end", self, "_on_drag_end")
	pass

func _input_event(viewport, event, shape_idx):
	_draggable._input_event(viewport, event, shape_idx)
	pass

func _process(delta):
	_draggable._process(delta)
	pass

func _on_drag_begin():
	emit_signal("on_drag_begin", self)
	pass

func _on_drag_end():
	emit_signal("on_drag_end", self)
	pass

# Enable or disable dragging.
func enable_dragging(dragging_enabled):
	_draggable.enable_dragging(dragging_enabled)
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
