# script: world

extends Node2D

# This is the action selected on the cursor.
onready var action = 0

func _ready():
	# Connecting the state change of the cursor.
	$cursor.connect("on_cursor_state_changed", self, "_on_cursor_state_changed")

	# Action icons.
	$critical_hit/icon_clickable.connect("on_icon_clicked", self, "_on_critical_hit_clicked")
	$counter_attack/icon_clickable.connect("on_icon_clicked", self, "_on_counter_attack_clicked")
	$magic_spell/icon_clickable.connect("on_icon_clicked", self, "_on_magic_spell_clicked")
	$constitution/icon_clickable.connect("on_icon_clicked", self, "_on_constitution_clicked")

	# Getting notified about the changes made on the playable field.
	$playable_container.connect("on_value_changed", self, "on_playable_value_changed")

	# Getting notified about the loading of the stages.
	$stage_manager.connect("on_stage_load", self, "_on_stage_load")

	# Rolling the selected dices button.
	$roll_selected/icon_clickable.connect("on_icon_clicked", self, "_on_roll_selected_clicked")

	# The game starts.
	$stage_manager.on_game_start()

	$hero/sprite.set_texture(load("res://res/character/hero_002.png"))
	$enemy/sprite.set_texture(load("res://res/character/skeleton_with_dagger.png"))
	$enemy.set_direction($enemy.DIRECTION.LEFT)
	$enemy.set_attack_thrust()

	# Initial state of the cursor.
	_on_critical_hit_clicked()
	pass

func _input(event):
	# By right clicking we increase the state.
	if event.is_action_pressed("right_click"):
		match action:
			1:
				_on_counter_attack_clicked()
			2, 3:
				_on_magic_spell_clicked()
			4:
				_on_constitution_clicked()
			5:
				_on_critical_hit_clicked()
	if event.is_action_pressed("left_click"):
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
	action = state
	$playable_container.set_dice_action(state)
	pass

# Rolling the selected dices.
func _on_roll_selected_clicked():
	$constitution.on_action()
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

func _on_critical_hit_clicked():
	$critical_hit.on_clicked()
	$roll_selected.set_visible(false)
	$cursor.set_state(1)
	pass

func _on_counter_attack_clicked():
	$counter_attack.on_clicked()
	$roll_selected.set_visible(false)
	$cursor.set_state(2)
	pass

func _on_magic_spell_clicked():
	$magic_spell.on_clicked()
	$roll_selected.set_visible(false)
	$cursor.set_state(3)
	pass

func _on_constitution_clicked():
	$constitution.on_clicked()
	$roll_selected.set_visible(true)
	$cursor.set_state(5)
	pass
