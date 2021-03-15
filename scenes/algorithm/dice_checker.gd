# script: dice_checker

extends Node

func check(dices, puzzles):
	# Null dice board is solved.
	if dices.size() == 0:
		return true

	# We can't solve a null puzzle.
	if puzzles.size() == 0:
		return false

	# Checking for individual matches.
	for p in range(0, puzzles.size()):
		for d in range(0, dices.size()):
			# If the corresponding puzzles element is null
			# then the only case when they will be equal and
			# that would mean the dices are null too so we
			# don't have to check them in that case.
			if puzzles[p] != null and puzzles[p] == dices[d]:
				dices[d] = null
				puzzles[p] = null

	# Finding all matches with joker puzzle dices.
	var dice_map = _make_map(dices)
	var puzzle_map = _make_map(puzzles)

	for i in range(0, puzzle_map.size()):
		var max_p_key = _find_max_key_in_map(puzzle_map)
		# If the key is greater then 0 then we have to check
		# the exact key in the dices.
		if max_p_key >= 0:
			if dice_map.has(max_p_key) and dice_map[max_p_key] >= puzzle_map[max_p_key]:
				dice_map[max_p_key] -= puzzle_map[max_p_key]
				# if dice_map[max_p_key] <= 0:
				#	dice_map.erase(max_p_key)
				puzzle_map.erase(max_p_key)
		else:
			# In this case we have to find joker appearances.
			var max_d_key = _find_max_key_in_map(dice_map)
			if max_d_key != null:
				if dice_map[max_d_key] >= puzzle_map[max_p_key]:
					dice_map[max_d_key] -= puzzle_map[max_p_key]
					# if dice_map[max_d_key] <= 0:
					#	dice_map.erase(max_d_key)
					puzzle_map.erase(max_p_key)
	return puzzle_map.size() == 0

# Making a map with the values and the count of them.
func _make_map(input_array):
	var result = {}
	for i in range(0, input_array.size()):
		if input_array[i] != null:
			if not result.has(input_array[i]):
				result[input_array[i]] = 1
			else:
				result[input_array[i]] += 1
	return result

# Finding the max of the values.
# It would probably a bit faster if we arrange them with
# an algorithm.
# Finding the max in every step is a bit slow but most of
# the times there are no more then 8-10 dices and puzzles
# at a time. The original game itself operates with 6 dices
# and 5 - 6 puzzles so it is probably not really an issue
# in my opinion.
func _find_max_key_in_map(map):
	var max_key
	var max_value
	for i in map.keys():
		if max_value == null or map[i] > max_value:
			max_value = map[i]
			max_key = i
	return max_key
