# script: world

extends Node2D

var fireball_class = preload("res://scenes/object/fireball/fireball.tscn")

enum GAME_STATE { NONE, CRITICAL_HIT, COUNTER_ATTACK, MAGIC_SPELL, CONSTITUTION, EXPERIENCE, END }
var game_state = GAME_STATE.NONE
var game_states = []

# This is the player character.
var player = null

# This is the character whom which we are in combat with.
var in_combat_character = null

# This is the action selected on the cursor.
onready var action = 0

func _ready():
	$control_layer/analog.visible = false

	# Connecting the state change of the cursor.
	$control_layer/cursor.connect("on_cursor_state_changed", self, "_on_cursor_state_changed")

	# Getting notified about the changes made on the playable field.
	$control_layer/input/playable_container.connect("on_value_changed", self, "on_playable_value_changed")
	# Getting notified about the prepared actions.
	$control_layer/input/playable_container.connect("on_prepared", self, "on_prepared")

	$control_layer/puzzle_container.visible = false

	# Getting notified about the loading of the stages.
	$stage_manager.connect("on_stage_load", self, "_on_stage_load")

	# Rolling the selected dices button.
	$control_layer/input/roll_selected/animation.play("spinning")

	# This is the player character.
	player=$terrain_layer/hero

	player.sprite_face = "res://scenes/character/res/hero_002.png"
	player.connect("on_fireball_summoned", self, "_on_fireball_summoned")

	$terrain_layer/enemy.connect("on_near_to_character", self, "_on_near_character")

	# Initial state of the cursor.
	_on_critical_hit_clicked()

	# Setting the basic preparation sequence.
	game_states = [ GAME_STATE.CRITICAL_HIT, GAME_STATE.COUNTER_ATTACK, GAME_STATE.MAGIC_SPELL, GAME_STATE.CONSTITUTION, GAME_STATE.EXPERIENCE ]
	# Setting the first preparation object.
	game_state_forward()
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
	# By left clicking we move the analog.
	if event.is_action_pressed("left_click"):
		$control_layer/analog.showAtPos(event.position)
		pass
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
		if in_combat_character != null:
			$control_layer/input/magic_spell/animation.play("magic_spell")
			player.spellcast()
			$in_combat_character.hurt()
			pass
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
		$control_layer/input/tent.on_clicked()
	pass

func _on_left_pressed():
	player.go("left")
	pass

func _on_up_pressed():
	player.go("up")
	pass

func _on_right_pressed():
	player.go("right")
	pass

func _on_down_pressed():
	player.go("down")
	pass

# On cursor state change.
func _on_cursor_state_changed(state):
	action = state
	$control_layer/input/playable_container.set_dice_action(state)

	if action == 6:
		game_state = GAME_STATE.CRITICAL_HIT
	pass

# Rolling the selected dices.
func _on_roll_selected_clicked():
	$control_layer/input/playable_container.roll_multiple()
	pass

# On loading the next stage.
func _on_stage_load(stage, playing_dices_count, puzzle):
	# The puzzle container should show this arrangement.
	$control_layer/puzzle_container.visible = true
	$control_layer/puzzle_container.set_arrangement(puzzle)

	# The playable container should show this count of dices.
	$control_layer/input/playable_container.visible = true
	$control_layer/input/playable_container.set_dice_count(playing_dices_count)
	pass

# The hero got near to this enemy.
func _on_near_character(near_character, stage_number):
	in_combat_character = near_character
	$stage_manager.load_stage(stage_number)
	pass

# Called when a dice action is completed.
func on_playable_value_changed(var dice):
	# If we are not in combat with any of the characters then we don't have to do anything here.
	if in_combat_character == null:
		return

	# Using the action.
	match action:
		1:
			$control_layer/input/critical_hit.on_action()
			player.attack()
			in_combat_character.hurt()
		2:
			$control_layer/input/counter_attack.on_action()
			player.hurt()
			in_combat_character.attack()
		3, 4:
			$control_layer/input/magic_spell.on_action()
			player.spellcast()
		5:
			$control_layer/input/constitution.on_action()
			player.attack()
			in_combat_character.hurt()
	# Checking the state of the gameboard.
	if $dice_checker.check($control_layer/input/playable_container.get_values(), $control_layer/puzzle_container.get_values()):
		# We won the puzzle.
		_on_win_puzzle()
		pass
	pass

func on_prepared(var dice):
	match game_state:
		GAME_STATE.CRITICAL_HIT:
			$control_layer/input/critical_hit.set_helper(dice)
			$control_layer/input/critical_hit/counter_bar.show_value(dice.get_value())
			pass
		GAME_STATE.COUNTER_ATTACK:
			$control_layer/input/counter_attack.set_helper(dice)
			$control_layer/input/counter_attack/counter_bar.show_value(dice.get_value())
			pass
		GAME_STATE.MAGIC_SPELL:
			$control_layer/input/magic_spell.set_helper(dice)
			$control_layer/input/magic_spell/counter_bar.show_value(dice.get_value())
			pass
		GAME_STATE.CONSTITUTION:
			$control_layer/input/constitution.set_helper(dice)
			$control_layer/input/constitution/counter_bar.show_value(dice.get_value())
			pass
		GAME_STATE.EXPERIENCE:
			$control_layer/input/tent.set_helper_dice(dice)
			pass

	if game_states.size() > 0:
		game_state_forward()
	else:
		$control_layer/input/playable_container.roll_all()
		$control_layer/input/playable_container.visible = false
		game_state = GAME_STATE.NONE
		$control_layer/cursor.set_state(0)
	pass

func _on_critical_hit_clicked():
	if not action == 6:
		$control_layer/input/critical_hit.on_clicked()
		$control_layer/input/roll_selected.set_visible(false)
		$control_layer/cursor.set_state(1)
		$control_layer/input/magic_spell.set_state(0)
	else:
		# Revoking the value.
		$control_layer/input/critical_hit.revoke_value()
		# Go back to the last state for the preparation.
		game_state_back(GAME_STATE.CRITICAL_HIT)
	pass

func _on_counter_attack_clicked():
	if not action == 6:
		$control_layer/input/counter_attack.on_clicked()
		$control_layer/input/roll_selected.set_visible(false)
		$control_layer/cursor.set_state(2)
		$control_layer/input/magic_spell.set_state(0)
	else:
		# Revoking the value.
		$control_layer/input/counter_attack.revoke_value()
		# Go back to the last state for the preparation.
		game_state_back(GAME_STATE.COUNTER_ATTACK)
	pass

func _on_magic_spell_clicked():
	if not action == 6:
		$control_layer/input/magic_spell.on_clicked()
		$control_layer/input/roll_selected.set_visible(false)
		$control_layer/cursor.set_state(3)
	else:
		# Revoking the value.
		$control_layer/input/magic_spell.revoke_value()
		# Go back to the last state for the preparation.
		game_state_back(GAME_STATE.MAGIC_SPELL)
	pass

func _on_constitution_clicked():
	if not action == 6:
		$control_layer/input/constitution.on_clicked()
		$control_layer/input/roll_selected.set_visible(true)
		$control_layer/cursor.set_state(5)
		$control_layer/input/magic_spell.set_state(0)
	else:
		# Revoking the value.
		$control_layer/constitution.revoke_value()
		# Go back to the last state for the preparation.
		game_state_back(GAME_STATE.CONSTITUTION)
	pass

func _on_tent_clicked(var dice):
	if action == 6 and dice != null:
		# Revoking value.
		# Showing the dice again.
		dice.visible = true
		# Go back to the last state for the preparation.
		game_state_back(GAME_STATE.EXPERIENCE)
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

func game_state_forward():
	game_state = game_states.pop_front()
	pass

func game_state_back(state):
	if state != game_state and not game_states.has(state):
		game_states.push_front(game_state)
		game_states.push_front(state)
		game_states.sort()
		game_states = game_states.pop_front()
	pass

func _on_win_puzzle():
	if in_combat_character != null:
		in_combat_character.die()
		in_combat_character = null
		pass
	pass
