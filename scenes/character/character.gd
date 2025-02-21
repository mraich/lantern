# script: character

extends Node2D

export(int) var speed_percent = 100 setget set_speed_percent
var speed = Vector2(48 / 3.4, 32 / 3.4) * 3

var stuck = false
var old_positions = []

# A fireball summoned signal.
signal on_fireball_summoned

# The look of the character.
export(String) var sprite_face = "res://scenes/character/res/hero_001.png" setget _update_sprite_face

# The direction of the character facing.
export(String, "up", "left", "down", "right") var direction setget set_direction

# The type of the attack the character does.
export(String, "thrust", "slash", "shoot") var attack setget set_attack

export(String, "idle", "spellcast", "thrust", "walk", "slash", "shoot", "hurt", "die", "dead", "resurrect", "turn_left_up", "turn_left_right", "turn_left_down", "turn_up_right", "turn_up_down", "turn_up_left", "turn_right_down", "turn_right_left", "turn_right_up", "turn_down_left", "turn_down_up", "turn_down_right", "spinning_left_right", "spinning_up_right", "spinning_right_right", "spinning_down_right") var state = "idle" setget set_state
var next_state = null

# This is the stage number to send when the hero arrives near this character.
export(int) var on_near_stage_number = 0

# Signal to send when the hero is near.
signal on_near_to_character

func _ready():
	# Listening to know if an amination is finished.
	$animation.connect("animation_finished", self, "_on_anim_finished")

	# Detecting when something wants to go through us.
	$area.connect("area_entered", self, "_on_legs_enter")
	$area.connect("area_exited", self, "_on_legs_exit")

	# Attack area.
	$attack_area.connect("area_entered", self, "_on_body_enter")

	# Nearing area.
	$near_area.connect("area_entered", self, "_on_body_near")
	pass

func set_speed_percent(new_speed_percent):
	speed_percent = new_speed_percent
	pass

func _update_sprite_face(newSpriteFace):
	if Engine.editor_hint:
		# Code to execute when in editor.
		pass

	# Changing the appearance of the hero.
	$sprite.set_texture(load(newSpriteFace))
	pass

func _on_body_enter(other):
	if other.name == "fireball":
		if other.friend != self:
			# Deleting the instance of the item.
			other.queue_free()
			# If dying or dead then fireball will not affect the character.
			if !is_dying() && !is_dead():
				set_state("hurt")
	pass

func _on_body_near(other):
	# Nearing an other character.
	if is_dead():
		# If we are dead we will not be near other characters.
		return
		pass
	# It means our near area crosses the area of that character.
	if other.name == "area" and $area != other:
		# This area is not our own area.
		if $area != other:
			# If we know who we are then we tell them.
			# This will initiate the stage loading function in the world node.
			if (on_near_stage_number != 0):
				emit_signal("on_near_to_character", self, on_near_stage_number)
				pass
			pass
	pass

func _on_legs_enter(other):
	# Including our attack area.
	if other.name == "attack_area":
		return
	# Any fireball should not affect the leg movement.
	if other.name == "fireball":
		return
	# Nearing an other character should not affect moving.
	if other.name == "near_area":
		return

	if not is_dead():
		# In every other cases we are stuck and we go idle
		stuck = true
		set_state("idle")
		pass
	pass

func _on_legs_exit(other):
	stuck = false
	pass

func _process(delta):
	var offset = Vector2(0, 0)
	var speed_scale = 1

	match state:
		"walk":
			match direction:
				"up":
					offset.y = -1
					speed_scale = scale.y
				"left":
					offset.x = -1
					speed_scale = scale.x
				"down":
					offset.y = 1
					speed_scale = scale.y
				"right":
					offset.x = 1
					speed_scale = scale.x

	if not stuck:
		old_positions.push_back(position)
		if old_positions.size() > 2:
			old_positions.pop_front()
		position += speed * delta * offset * speed_percent / 100 * speed_scale
	else:
		if old_positions.size() > 0:
			position = old_positions.pop_front()
		stuck = false
	pass

func set_state(new_state):
	# Dead characters will not do anything.
	if not state_changeable():
		return
	if next_state == null:
		next_state = new_state
		_update_animation_by_direction()
		return
	next_state = new_state
	pass

func set_direction(new_direction):
	if direction == new_direction:
		return
	direction = new_direction

	# Let's update the animation.
	_update_animation_by_direction()
	pass

# Called when az animation is finished.
func _on_anim_finished(anim_name):
	# Automatic transitions between states.
	# The other states are periodic because we set them again in the _update_animation_by_direction function.
	match state:
		"idle", "spellcast", "thrust", "slash", "shoot", "hurt", "recurrect":
			if state == "spellcast":
				# Telling the outside world that a fireball must be summoned.
				emit_signal("on_fireball_summoned", self, position - Vector2(0, scale.y * 22), direction)
			set_state("idle")
		"turn_left_up", "turn_left_right", "turn_left_down", "turn_up_right", "turn_up_down", "turn_up_left", "turn_right_down", "turn_right_left", "turn_right_up", "turn_down_left", "turn_down_up", "turn_down_right":
			match state:
				"turn_down_left", "turn_up_left", "turn_right_left":
					set_direction("left")
				"turn_left_up", "turn_right_up", "turn_down_up":
					set_direction("up")
				"turn_up_right", "turn_down_right", "turn_left_right":
					set_direction("right")
				"turn_right_down", "turn_left_down", "turn_up_down":
					set_direction("down")
			set_state("idle")
		"spinning_left_right", "spinning_up_right", "spinning_right_right", "spinning_down_right":
			set_direction("down")
			set_state("die")
		"die":
			set_direction("down")
			set_state("dead")

	_update_animation_by_direction()
	pass

# Choosing the animation keeping in mind the direction.
func _update_animation_by_direction():
	if next_state != null:
		state = next_state
		next_state = null
	$animation.stop();

	match state:
		# These animations are affected by the direction.
		"idle", "spellcast", "thrust", "walk", "slash", "shoot":
			$animation.play(state + "_" + direction)
		# These animations are not affected by the direction.
		"hurt", "die", "dead", "resurrect":
			$animation.play(state)
		# Turning.
		"turn_left_up", "turn_left_right", "turn_left_down", "turn_up_right", "turn_up_down", "turn_up_left", "turn_right_down", "turn_right_left", "turn_right_up", "turn_down_left", "turn_down_up", "turn_down_right":
			$animation.play(state)
		# Spinning.
		"spinning_left_right", "spinning_up_right", "spinning_right_right", "spinning_down_right":
			$animation.play(state)
	pass

func is_dying():
	return state == "spinning_left_right" || state == "spinning_up_right" || state == "spinning_right_right" || state == "spinning_down_right" || state == "die"

func is_dead():
	return is_dying() || state == "dead"

func state_changeable():
	return state != "dead"

func _can_interrupt():
	return !is_dead() || state == "walk"

func go(where):
	if !_can_interrupt():
		return

	if direction == where:
		set_state("walk")
	else:
		set_state("turn_" + direction + "_" + where)
	pass

func slash():
	set_state("slash")
	pass

func hurt():
	set_state("hurt")
	pass

func set_attack(new_attack):
	attack = new_attack
	pass

func attack():
	set_state(attack)
	pass

func spellcast():
	set_state("spellcast")
	pass

func stop():
	set_state("idle")
	pass

func die():
	match direction:
		"left":
			set_state("spinning_left_right")
		"up":
			set_state("spinning_up_right")
		"right":
			set_state("spinning_right_right")
		"down":
			set_state("spinning_down_right")
	pass
