# script: dice_clickable

extends "res://scenes/dice/dice_rollable.gd"

func _ready():
	pass

func set_input_action(input_action):
	if not InputMap.has_action(input_action):
		InputMap.add_action(input_action)
	$button.action = input_action
	pass
