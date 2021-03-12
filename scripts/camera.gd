# script: camera

extends Camera2D

var scenes_followed = []

var scene_followed = null

func _ready():
	pass

func _physics_process(delta):
	if scene_followed != null and weakref(scene_followed).get_ref():
		var position = scene_followed.get_position()
		set_position(position)
		pass
	else:
		scene_followed = scenes_followed.pop_back()
		pass
	pass

func get_total_pos():
	return position + offset
	pass

func set_follow(to_follow):
	scenes_followed = []
	scene_followed = to_follow
	pass

func push_follow(to_follow):
	scenes_followed.push_back(scene_followed)
	scene_followed = to_follow
	pass

func not_follow(to_not_follow):
	if scene_followed == to_not_follow:
		scene_followed = null

	var i = 0
	for scene in scenes_followed:
		if (scene == to_not_follow):
			scenes_followed.remove(i)
		i += 1
	pass
