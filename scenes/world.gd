# script: world

extends Node2D

var fireball_class = preload("res://scenes/object/fireball/fireball.tscn")

enum PREPARE_STATE { NONE, CRITICAL_HIT, COUNTER_ATTACK, MAGIC_SPELL, CONSTITUTION, EXPERIENCE, END }
var prepare_state = PREPARE_STATE.NONE
var prepared_states = []

# This is the action selected on the cursor.
onready var action = 0

func _ready():
	# Connecting the state change of the cursor.
	$control_layer/cursor.connect("on_cursor_state_changed", self, "_on_cursor_state_changed")

	# Action icons.
	$control_layer/critical_hit/counter_bar.set_bar_count(7)
	$control_layer/counter_attack/counter_bar.set_bar_count(7)
	$control_layer/magic_spell/counter_bar.set_bar_count(7)
	$control_layer/constitution/counter_bar.set_bar_count(7)

	# Getting notified about the changes made on the playable field.
	$control_layer/playable_container.connect("on_value_changed", self, "on_playable_value_changed")
	# Getting notified about the prepared actions.
	$control_layer/playable_container.connect("on_prepared", self, "on_prepared")

	$control_layer/puzzle_container.visible = false

	# Getting notified about the loading of the stages.
	$stage_manager.connect("on_stage_load", self, "_on_stage_load")

	# Rolling the selected dices button.
	$control_layer/roll_selected/animation.play("spinning")

	$terrain_layer/hero/sprite.set_texture(load("res://scenes/character/res/hero_002.png"))
	$terrain_layer/hero.connect("on_fireball_summoned", self, "_on_fireball_summoned")
	$terrain_layer/enemy/sprite.set_texture(load("res://scenes/character/res/skeleton_with_dagger.png"))
	$terrain_layer/enemy.set_direction($terrain_layer/enemy.DIRECTION.LEFT)
	$terrain_layer/enemy.set_attack_thrust()
	$terrain_layer/enemy.set_on_near_stage_number(1)
	$terrain_layer/enemy.connect("on_near_to_character", self, "_on_near_character")

	# Initial state of the cursor.
	_on_critical_hit_clicked()

	# Initial values for counters.
	$control_layer/critical_hit/counter_bar.show_value(0)
	$control_layer/counter_attack/counter_bar.show_value(0)
	$control_layer/magic_spell/counter_bar.show_value(0)
	$control_layer/constitution/counter_bar.show_value(0)

	# Rolling every dice for stats.
	# There are 6 stats we have to arrange.
	$control_layer/playable_container.set_dice_count(6)
	$control_layer/playable_container.roll_all()

	# Setting the basic preparation sequence.
	prepared_states = [ PREPARE_STATE.CRITICAL_HIT, PREPARE_STATE.COUNTER_ATTACK, PREPARE_STATE.MAGIC_SPELL, PREPARE_STATE.CONSTITUTION, PREPARE_STATE.EXPERIENCE ]
	# Setting the first preparation object.
	preparation_forward()
	# Aiming for preparation with the cursor.
	$control_layer/cursor.set_state(6)

	# We follow the hero with the camera.
	# 300 x 400 is at the center of the screen as its resolution is 600 x 800.
	# The dimension of the hero sprite is 64 x 64.
	$camera.offset = Vector2(-1 * ((600 - 64) / 2) + 64 * 2, -1 * ((800 - 64) / 2))
	$camera.set_follow($terrain_layer/hero)
	pass

func _process(delta):
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
		_on_left_pressed()
	if event.is_action_pressed("ui_up"):
		_on_up_pressed()
	if event.is_action_pressed("ui_right"):
		_on_right_pressed()
	if event.is_action_pressed("ui_down"):
		_on_down_pressed()
	if event.is_action_pressed("ui_stop"):
		$terrain_layer/hero.stop()
	if event.is_action_pressed("ui_constitution_selected"):
		_on_constitution_clicked()
	if event.is_action_pressed("ui_counter_attack_selected"):
		_on_counter_attack_clicked()
	if event.is_action_pressed("ui_critical_hit_selected"):
		_on_critical_hit_clicked()
	if event.is_action_pressed("ui_magic_spell_selected"):
		_on_magic_spell_clicked()
	if event.is_action_pressed("ui_roll_selected_selected"):
		_on_roll_selected_clicked()
	if event.is_action_pressed("ui_tent_selected"):
		$control_layer/tent.on_clicked()
	pass

func _on_left_pressed():
	$terrain_layer/hero.go_left()
	pass

func _on_up_pressed():
	$terrain_layer/hero.go_up()
	pass

func _on_right_pressed():
	$terrain_layer/hero.go_right()
	pass

func _on_down_pressed():
	$terrain_layer/hero.go_down()
	pass

# On cursor state change.
func _on_cursor_state_changed(state):
	action = state
	$control_layer/playable_container.set_dice_action(state)

	if action == 6:
		prepare_state = PREPARE_STATE.CRITICAL_HIT
	pass

# Rolling the selected dices.
func _on_roll_selected_clicked():
	$control_layer/playable_container.roll_multiple()
	pass

# On loading the next stage.
func _on_stage_load(stage, playing_dices_count, puzzle):
	# Analog should not be visible while combat.
	$control_layer/analog.visible = false

	# The puzzle container should show this arrangement.
	$control_layer/puzzle_container.visible = true
	$control_layer/puzzle_container.set_arrangement(puzzle)

	# The playable container should show this count of dices.
	$control_layer/playable_container.visible = true
	$control_layer/playable_container.set_dice_count(playing_dices_count)
	pass

# The hero got near to this enemy.
func _on_near_character(near_character, stage_number):
	$stage_manager.load_stage(stage_number)
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
		_on_win_puzzle()
		pass
	pass

func on_prepared(var dice):
	match prepare_state:
		PREPARE_STATE.CRITICAL_HIT:
			$control_layer/critical_hit.set_helper(dice)
			$control_layer/critical_hit/counter_bar.show_value(dice.get_value())
			pass
		PREPARE_STATE.COUNTER_ATTACK:
			$control_layer/counter_attack.set_helper(dice)
			$control_layer/counter_attack/counter_bar.show_value(dice.get_value())
			pass
		PREPARE_STATE.MAGIC_SPELL:
			$control_layer/magic_spell.set_helper(dice)
			$control_layer/magic_spell/counter_bar.show_value(dice.get_value())
			pass
		PREPARE_STATE.CONSTITUTION:
			$control_layer/constitution.set_helper(dice)
			$control_layer/constitution/counter_bar.show_value(dice.get_value())
			pass
		PREPARE_STATE.EXPERIENCE:
			$control_layer/tent.set_helper_dice(dice)
			pass

	if prepared_states.size() > 0:
		preparation_forward()
	else:
		$control_layer/playable_container.roll_all()
		$control_layer/playable_container.visible = false
		$control_layer/analog.visible = true
		prepare_state = PREPARE_STATE.NONE
		$control_layer/cursor.set_state(0)
	pass

func _on_critical_hit_clicked():
	if not action == 6:
		$control_layer/critical_hit.on_clicked()
		$control_layer/roll_selected.set_visible(false)
		$control_layer/cursor.set_state(1)
		$control_layer/magic_spell.set_state(0)
	else:
		# Revoking the value.
		$control_layer/critical_hit.revoke_value()
		# Go back to the last state for the preparation.
		preparation_back(PREPARE_STATE.CRITICAL_HIT)
	pass

func _on_counter_attack_clicked():
	if not action == 6:
		$control_layer/counter_attack.on_clicked()
		$control_layer/roll_selected.set_visible(false)
		$control_layer/cursor.set_state(2)
		$control_layer/magic_spell.set_state(0)
	else:
		# Revoking the value.
		$control_layer/counter_attack.revoke_value()
		# Go back to the last state for the preparation.
		preparation_back(PREPARE_STATE.COUNTER_ATTACK)
	pass

func _on_magic_spell_clicked():
	if not action == 6:
		$control_layer/magic_spell.on_clicked()
		$control_layer/roll_selected.set_visible(false)
		$control_layer/cursor.set_state(3)
	else:
		# Revoking the value.
		$control_layer/magic_spell.revoke_value()
		# Go back to the last state for the preparation.
		preparation_back(PREPARE_STATE.MAGIC_SPELL)
	pass

func _on_constitution_clicked():
	if not action == 6:
		$control_layer/constitution.on_clicked()
		$control_layer/roll_selected.set_visible(true)
		$control_layer/cursor.set_state(5)
		$control_layer/magic_spell.set_state(0)
	else:
		# Revoking the value.
		$control_layer/constitution.revoke_value()
		# Go back to the last state for the preparation.
		preparation_back(PREPARE_STATE.CONSTITUTION)
	pass

func _on_tent_clicked(var dice):
	if action == 6 and dice != null:
		# Revoking value.
		# Showing the dice again.
		dice.visible = true
		# Go back to the last state for the preparation.
		preparation_back(PREPARE_STATE.EXPERIENCE)
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

func preparation_forward():
	prepare_state = prepared_states.pop_front()
	pass

func preparation_back(state):
	if state != prepare_state and not prepared_states.has(state):
		prepared_states.push_front(prepare_state)
		prepared_states.push_front(state)
		prepared_states.sort()
		prepare_state = prepared_states.pop_front()
	pass

func _on_win_puzzle():
	$terrain_layer/enemy.die()
	pass
