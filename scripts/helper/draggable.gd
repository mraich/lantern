# script: draggable
# It can be used on a StaticBody2D.
# The pickable attribute must be se to enabled.

extends Node

# The body we will drag.
var _draggable_body
# Tells if we are dragging the _draggable_body now.
var _drag = false
# This is the offset.
var _drag_offset = Vector2()

# Setting the _draggable_body.
func set_draggable_body(draggable_body):
	self._draggable_body = draggable_body
	pass

# This is the _input_event where we catch the event of dragging.
# It must be called in the script of the body we want to move.
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		# Setting values for dragging.
		# If the moust button is pressed we drag the dice.
		_drag = event.pressed
		_drag_offset = _draggable_body.position - _draggable_body.get_global_mouse_position()
	pass

# This is the _process_event, where the _draggable_body will actually move.
# It must be called in the script of the body we want to move.
func _process(delta):
	if _drag:
		# When we drag the dice we move it according to the position of the mouse.
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			_draggable_body.position = _draggable_body.get_global_mouse_position() + _drag_offset
	pass
