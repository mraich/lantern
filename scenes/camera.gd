# script: camera

extends Camera2D

# We can follow multiple scenes.
var scenes_followed = []

# This is the scene we follow at the moment.
var scene_followed = null

func _ready():
	pass

func _physics_process(delta):
	if scene_followed != null and weakref(scene_followed).get_ref():
		# When we have a nice usable scene to follow.
		var position = scene_followed.get_position()
		set_position(position)
		pass
	else:
		# If the scene we follow becomes null or gets deleted then we must follow the last scene we followed before.
		scene_followed = scenes_followed.pop_back()
		pass
	pass

func get_total_pos():
	return position + offset
	pass

# Set follow only this scene.
func set_follow(to_follow):
	scenes_followed = []
	scene_followed = to_follow
	pass

# Replace just the followed scene but leave the list intact.
func replace_follow(to_follow):
	scene_followed = to_follow
	pass

# Follow this scene but remember the last scene.
func push_follow(to_follow):
	scenes_followed.push_back(scene_followed)
	scene_followed = to_follow
	pass

# Don't follow and don't remember this scene.
func not_follow(to_not_follow):
	if scene_followed == to_not_follow:
		scene_followed = null

	var i = 0
	for scene in scenes_followed:
		if (scene == to_not_follow):
			scenes_followed.remove(i)
		i += 1
	pass
