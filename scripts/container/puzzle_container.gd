# script: puzzle_container

extends "res://scripts/container/dice_container.gd"

var puzzle_class = preload("res://scenes/dice/puzzle.tscn")

func _ready():
	init(puzzle_class)

	var arrangement = [1, 2, 3, 4, -1, -2]
	set_arrangement(arrangement)
	pass
