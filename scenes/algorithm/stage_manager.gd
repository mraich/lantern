# script: stage_manager

extends Node

# On which stage are we in.
var stage

# Emitted when we loaded a new stage.
signal on_stage_load

func load_stage(stage):
	var stage_data = $stage_database.DATA[stage]
	emit_signal("on_stage_load", stage, stage_data[1], stage_data[2])
	pass
