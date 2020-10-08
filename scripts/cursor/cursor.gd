# script: cursor

extends Node2D

# Signal to notify when the state of the cursor is changed.
signal on_cursor_state_changed

# States should be between 0 and 4.
const _MAX_STATES = 5

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
	_state = new_state

	# Notifying the outside world that our state is changed.
	emit_signal("on_cursor_state_changed", _state)
	pass
