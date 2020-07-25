# script: dice_playable

extends "res://scripts/dice/dice_rollable.gd"

var _drag = false
var _drag_offset = Vector2()

func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		# Setting values for dragging.
		# If the moust button is pressed we drag the dice.
		_drag = event.pressed
		_drag_offset = position - get_global_mouse_position()
	pass

func _process(delta):
	if _drag:
		# When we drag the dice we move it according to the position of the mouse.
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			position = get_global_mouse_position() + _drag_offset
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
