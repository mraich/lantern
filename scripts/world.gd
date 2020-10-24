#script: world

extends Node2D

# Finding the cursor in the tree of the world.
onready var cursor = get_node("cursor")

# Finding the dice container in the tree of the world.
onready var playable_container = get_node("playable_container")
onready var puzzle_container = get_node("puzzle_container")

func _ready():
	# Connecting the state change of the cursor.
	cursor.connect("on_cursor_state_changed", self, "_on_cursor_state_changed")

	# Initial state of the cursor.
	cursor.set_state(0)

	# Getting notified about the changes made on the playable field.
	playable_container.connect("on_value_changed", self, "on_playable_value_changed")
	pass

func _input(event):
	# By right clicking we increase the state.
	if event.is_action_pressed("right_click"):
		cursor.step_state()
	pass

# On cursor state change.
func _on_cursor_state_changed(state):
	playable_container.set_dice_action(state)
	pass

func on_playable_value_changed(dice):
	pass
