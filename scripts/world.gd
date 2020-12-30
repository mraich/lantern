# script: world

extends Node2D

func _ready():
	# Connecting the state change of the cursor.
	$cursor.connect("on_cursor_state_changed", self, "_on_cursor_state_changed")

	# Initial state of the cursor.
	$cursor.set_state(0)

	# Getting notified about the changes made on the playable field.
	$playable_container.connect("on_value_changed", self, "on_playable_value_changed")

	# Getting notified about the loading of the stages.
	$stage_manager.connect("on_stage_load", self, "_on_stage_load")

	# Rolling the selected dices button.
	$roll_selected.connect("on_dice_clicked", self, "_on_roll_selected_clicked")

	# The game starts.
	$stage_manager.on_game_start()

	$hero/sprite.set_texture(load("res://res/character/hero_002.png"))
	$enemy/sprite.set_texture(load("res://res/character/skeleton_with_dagger.png"))
	$enemy.set_direction($enemy.DIRECTION.LEFT)
	$enemy.set_attack_thrust()
	pass

func _input(event):
	# By right clicking we increase the state.
	if event.is_action_pressed("right_click"):
		$cursor.step_state()
	if event.is_action_pressed("left_click"):
		$critical_hit/animation.play("critical_hit")
		$counter_attack/animation.play("counter_attack")
		$magic_spell/animation.play("magic_spell")
		$constitution/animation.play("constitution")
		$hero.attack()
		$enemy.hurt()
	if event.is_action_pressed("ui_attack"):
		$magic_spell/animation.play("magic_spell")
		$hero.spellcast()
		$enemy.hurt()
	if event.is_action_pressed("ui_left"):
		$hero.go_left()
	if event.is_action_pressed("ui_up"):
		$hero.go_up()
	if event.is_action_pressed("ui_right"):
		$hero.go_right()
	if event.is_action_pressed("ui_down"):
		$hero.go_down()
	pass

# On cursor state change.
func _on_cursor_state_changed(state):
	$playable_container.set_dice_action(state)
	$roll_selected.set_value(state)
	pass

# Rolling the selected dices.
func _on_roll_selected_clicked():
	$playable_container.roll_multiple()
	pass

# On loading the next stage.
func _on_stage_load(stage, playing_dices_count, puzzle):
	# The puzzle container should show this arrangement.
	$puzzle_container.set_arrangement(puzzle)

	# The playable container should show this count of dices.
	$playable_container.set_dice_count(playing_dices_count)
	# New set of values for the dices.
	$playable_container.roll_all()
	pass

# Called when a dice action is completed.
func on_playable_value_changed():
	# Checking the state of the gameboard.
	if $dice_checker.check($playable_container.get_values(), $puzzle_container.get_values()):
		# We won the puzzle.
		$stage_manager.on_stage_win()
		pass
	pass
