# script: tilemap

extends Node2D

var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()

	# var terrains = [ 0, 5 ]
	# for i in range(-10, 10):
	# 	for b in range(-10, 10):
	# 		var new_value = random.randi_range(0, 1)
	# 		var index:int = randi() % terrains.size()
	# 		$tilemap.set_cell(i, b, terrains[index])
	# 		pass
	# 	pass

	# Defining map size.
	var map_size = 10

	# Default color.
	for i in range(-map_size, map_size):
		for b in range(-map_size, map_size):
			$tilemap.set_cell(i, b, 0)
			pass
		pass

	# Creating patches.
	var patch_count = map_size
	for p in range(0, patch_count):
		var start_x = random.randi_range(-map_size, map_size)
		var start_y = random.randi_range(-map_size, map_size)
		var end_x = start_x + random.randi_range(1, map_size / 3)
		var end_y = start_y + random.randi_range(1, map_size / 3)
		if (start_x + end_x > map_size):
			start_x -= map_size - end_x
		if (start_y + end_y > map_size):
			start_y -= map_size - end_y
		
		for i in range(start_x, end_x):
			for b in range(start_y, end_y):
				$tilemap.set_cell(i, b, 23)
				pass
			pass
		pass
	pass
