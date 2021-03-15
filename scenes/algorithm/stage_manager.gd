# script: stage_manager

extends Node

# On which stage are we in.
var stage

# Emitted when we loaded a new stage.
signal on_stage_load

func on_game_start():
	stage = 0
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
	if stage >= $stage_database.DATA.size():
		return

	var stage_data = $stage_database.DATA[stage]
	emit_signal("on_stage_load", stage + 1, stage_data[1], stage_data[2])
	pass
