# script: puzzle_container

extends "res://scripts/container/dice_container.gd"

var playable_class = preload("res://scenes/dice/dice_playable.tscn")

func _ready():
	init(playable_class)

	set_dice_count(6)
	pass
