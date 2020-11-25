# script: stage_manager

extends Node

var stage = 1

# Puzzle variable.
onready var puzzle = [1, 2, 3, 4, 5, 6]

# Dices count to play.
onready var playing_dices_count = 6

# Emitted when we loaded a new stage.
signal on_stage_load

func on_game_start():
	stage = 1
	_load_stage()
	pass

func on_stage_win():
	stage += 1
	_load_stage()
	pass

func on_stage_lose():
	on_game_start()
	pass

func _load_stage():
	emit_signal("on_stage_load", stage, playing_dices_count, puzzle)
	pass
