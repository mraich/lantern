# script: cursor

extends Node2D

# Signal to notify when the state of the cursor is changed.
signal on_cursor_state_changed

# States should be between 0 and 5.
const _MAX_STATES = 6

# Initial state.
var _state = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _process(delta):
	self.position = self.get_global_mouse_position()
	pass

# Setting the next state.
func step_state():
	set_state((_state + 1) % _MAX_STATES)
	pass

# Setting the state.
func set_state(new_state):
	# We don't use idle state for now.
	if new_state == 0:
		new_state = 1

	# If we are in the magic spell state we alternate between adding or decreasing the value.
	if _state == new_state:
		if _state == 3:
			new_state = 4
		if _state == 4:
			new_state = 3
		pass

	_state = new_state

	# Notifying the outside world that our state is changed.
	emit_signal("on_cursor_state_changed", _state)
	pass

func get_state():
	return _state
