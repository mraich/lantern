#script: world

extends Node2D

# Finding the cursor in the tree of the world.
onready var cursor = get_node("cursor")

func _ready():
	# Connecting the state change of the cursor.
	cursor.connect("on_cursor_state_changed", self, "_on_cursor_state_changed")

	# Initial state of the cursor.
	cursor.set_state(0)
	pass

# On cursor state change.
func _on_cursor_state_changed(state):
	pass
