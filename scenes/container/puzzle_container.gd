# script: puzzle_container

extends "res://scenes/container/dice_container.gd"

var puzzle_class = preload("res://scenes/dice/puzzle.tscn")

func _ready():
	init(puzzle_class)
	pass
