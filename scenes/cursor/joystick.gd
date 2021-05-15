# script: joystick

extends Node2D

var state = null

var is_pressing = false
var original_position = null

signal on_joystick_heading_changed

func _ready():
	pass

# Capturing the input events.
func _input_event(viewport, event, shape_idx):
	# We are only interested in left clicks now.
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			self.original_position = self.get_global_mouse_position()
			self.is_pressing = true
			pass
		if event.is_action_released("left_click"):
			self.is_pressing = false
			pass
		pass
	pass

func _process(delta):
	if is_pressing and not original_position == null:
		var position_delta = self.get_global_mouse_position() - original_position
		if sqrt(pow(position_delta.x, 2) + pow(position_delta.y, 2)) > 10:
			# It is far enough from the original position.
			var angle = rad2deg(position_delta.angle())
			if (angle > 135 and angle < 180) or (angle > -180 and angle < -135):
				# Left.
				_set_state(0)
				pass
			if angle > -135 and angle < -45:
				# Up.
				_set_state(1)
				pass
			if angle > -45 and angle < 45:
				# Right.
				_set_state(2)
				pass
			if angle > 45 and angle < 135:
				# Down.
				_set_state(3)
				pass
			pass
		else:
			_set_state(-1)
		pass
	else:
		_set_state(-1)
	pass

# -1 - Idle.
# 0 - Left.
# 1 - Up.
# 2 - Right.
# 3 - Down.
func _set_state(state):
	if not self.state == state:
		emit_signal("on_joystick_heading_changed", state)
		pass
	self.state = state
	pass
