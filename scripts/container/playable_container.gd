# script: puzzle_container

extends "res://scripts/container/dice_container.gd"

var playable_class = preload("res://scenes/dice/dice_playable.tscn")

func _ready():
	init(playable_class)
	pass

func set_dice_action(action):
	for dice in dices:
		dice.set_action(action)
	pass

# Rolling all of the dices.
func roll_all():
	for dice in dices:
		dice.roll()
	pass

# Rolling all of the dices which were selected for rolling.
func roll_multiple():
	for dice in dices:
		dice.roll_multiple()
	pass
