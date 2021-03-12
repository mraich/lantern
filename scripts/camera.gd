# script: camera

extends Camera2D

var scene_followed = null

func _ready():
	pass

func _physics_process(delta):
	if scene_followed != null and weakref(scene_followed).get_ref():
		var position = scene_followed.get_position()
		set_position(position)
		pass
	pass

func get_total_pos():
	return position + offset
	pass
