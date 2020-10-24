# script: puzzle_container

extends "res://scripts/container/dice_container.gd"

var playable_class = preload("res://scenes/dice/dice_playable.tscn")

func _ready():
	init(playable_class)

	set_dice_count(6)
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
