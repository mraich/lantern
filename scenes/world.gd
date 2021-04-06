# script: world

extends Node2D

var fireball_class = preload("res://scenes/object/fireball/fireball.tscn")

# This is the action selected on the cursor.
onready var action = 0

func _ready():
	# Connecting the state change of the cursor.
	$control_layer/cursor.connect("on_cursor_state_changed", self, "_on_cursor_state_changed")

	# Action icons.
	$control_layer/critical_hit/icon_clickable.connect("on_icon_clicked", self, "_on_critical_hit_clicked")
	$control_layer/critical_hit/counter_bar.set_bar_count(7)
	$control_layer/counter_attack/icon_clickable.connect("on_icon_clicked", self, "_on_counter_attack_clicked")
	$control_layer/counter_attack/counter_bar.set_bar_count(7)
	$control_layer/magic_spell/icon_clickable.connect("on_icon_clicked", self, "_on_magic_spell_clicked")
	$control_layer/magic_spell/counter_bar.set_bar_count(7)
	$control_layer/constitution/icon_clickable.connect("on_icon_clicked", self, "_on_constitution_clicked")
	$control_layer/constitution/counter_bar.set_bar_count(7)

	# Getting notified about the changes made on the playable field.
	$control_layer/playable_container.connect("on_value_changed", self, "on_playable_value_changed")
	# Getting notified about the prepared actions.
	$control_layer/playable_container.connect("on_prepared", self, "on_prepared")

	# Getting notified about the loading of the stages.
	$stage_manager.connect("on_stage_load", self, "_on_stage_load")

	# Rolling the selected dices button.
	$control_layer/roll_selected/icon_clickable.connect("on_icon_clicked", self, "_on_roll_selected_clicked")
	$control_layer/roll_selected/animation.play("spinning")

	# The game starts.
	$stage_manager.on_game_start()

	$terrain_layer/hero/sprite.set_texture(load("res://scenes/character/res/hero_002.png"))
	$terrain_layer/hero.connect("on_fireball_summoned", self, "_on_fireball_summoned")
	$terrain_layer/enemy/sprite.set_texture(load("res://scenes/character/res/skeleton_with_dagger.png"))
	$terrain_layer/enemy.set_direction($terrain_layer/enemy.DIRECTION.LEFT)
	$terrain_layer/enemy.set_attack_thrust()

	# Initial state of the cursor.
	_on_critical_hit_clicked()

	# Initial values for counters.
	$control_layer/critical_hit/counter_bar.show_value(7)
	$control_layer/counter_attack/counter_bar.show_value(7)
	$control_layer/magic_spell/counter_bar.show_value(7)
	$control_layer/constitution/counter_bar.show_value(7)

	# We follow the hero with the camera.
	# 300 x 400 is at the center of the screen as its resolution is 600 x 800.
	# The dimension of the hero sprite is 64 x 64.
	$camera.offset = Vector2(-1 * ((600 - 64) / 2) + 64 * 2, -1 * ((800 - 64) / 2))
	$camera.set_follow($terrain_layer/hero)

	$control_layer/cursor.set_state(6)
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
	if event.is_action_pressed("ui_attack"):
		$control_layer/magic_spell/animation.play("magic_spell")
		$terrain_layer/hero.spellcast()
		$terrain_layer/enemy.hurt()
	if event.is_action_pressed("ui_left"):
		$terrain_layer/hero.go_left()
	if event.is_action_pressed("ui_up"):
		$terrain_layer/hero.go_up()
	if event.is_action_pressed("ui_right"):
		$terrain_layer/hero.go_right()
	if event.is_action_pressed("ui_down"):
		$terrain_layer/hero.go_down()
	pass

# On cursor state change.
func _on_cursor_state_changed(state):
	action = state
	$control_layer/playable_container.set_dice_action(state)
	pass

# Rolling the selected dices.
func _on_roll_selected_clicked():
	$control_layer/playable_container.roll_multiple()
	pass

# On loading the next stage.
func _on_stage_load(stage, playing_dices_count, puzzle):
	# The puzzle container should show this arrangement.
	$control_layer/puzzle_container.set_arrangement(puzzle)

	# The playable container should show this count of dices.
	$control_layer/playable_container.set_dice_count(playing_dices_count)
	# New set of values for the dices.
	$control_layer/playable_container.roll_all()
	pass

# Called when a dice action is completed.
func on_playable_value_changed(var dice):
	# Using the action.
	match action:
		1:
			$control_layer/critical_hit.on_action()
			$terrain_layer/hero.attack()
			$terrain_layer/enemy.hurt()
		2:
			$control_layer/counter_attack.on_action()
			$terrain_layer/hero.hurt()
			$terrain_layer/enemy.attack()
		3, 4:
			$control_layer/magic_spell.on_action()
			$terrain_layer/hero.spellcast()
		5:
			$control_layer/constitution.on_action()
			$terrain_layer/hero.attack()
			$terrain_layer/enemy.hurt()
	# Checking the state of the gameboard.
	if $dice_checker.check($control_layer/playable_container.get_values(), $control_layer/puzzle_container.get_values()):
		# We won the puzzle.
		$stage_manager.on_stage_win()
		pass
	pass

func on_prepared(var dice):
	pass

func _on_critical_hit_clicked():
	$control_layer/critical_hit.on_clicked()
	$control_layer/roll_selected.set_visible(false)
	$control_layer/cursor.set_state(1)
	$control_layer/magic_spell.set_state(0)
	pass

func _on_counter_attack_clicked():
	$control_layer/counter_attack.on_clicked()
	$control_layer/roll_selected.set_visible(false)
	$control_layer/cursor.set_state(2)
	$control_layer/magic_spell.set_state(0)
	pass

func _on_magic_spell_clicked():
	$control_layer/magic_spell.on_clicked()
	$control_layer/roll_selected.set_visible(false)
	$control_layer/cursor.set_state(3)
	pass

func _on_constitution_clicked():
	$control_layer/constitution.on_clicked()
	$control_layer/roll_selected.set_visible(true)
	$control_layer/cursor.set_state(5)
	$control_layer/magic_spell.set_state(0)
	pass

func _on_fireball_summoned(other, position, fireball_direction):
	# Creating a new fireball.
	var fireball = fireball_class.instance()
	# Setting the friend who can't be hurt until they overlapped once.
	# It will be usually the summoner character.
	fireball.set_summoner(other)
	fireball.z_index = other.z_index - 1
	# Setting its size.
	fireball.scale.x = 3
	fireball.scale.y = 3
	# Setting its position.
	fireball.position = position
	# Setting its direction.
	fireball.set_direction(fireball_direction)
	add_child(fireball)
	pass