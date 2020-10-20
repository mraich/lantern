# script: puzzle_container

extends "res://scripts/container/dice_container.gd"

var puzzle_class = preload("res://scenes/dice/puzzle.tscn")

func _ready():
	init(puzzle_class, 6)
	pass
