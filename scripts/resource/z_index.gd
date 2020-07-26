# script : z_index
# It helps to maintain the z index of a group of objects.

extends Resource

var max_z_index = 0
var z_index = 0

# These are the objects we will manage the z index for.
var objects = []

func _set_objects(objects):
	self.objects = objects
	max_z_index = objects.size()
	pass

func _change_z_index_to_max(object):
	z_index += 1
	object.set_z_index(z_index)

	if z_index > max_z_index:
		for object_it in objects:
			object_it.set_z_index(object_it.get_z_index() - max_z_index)
		z_index -= max_z_index
	pass
