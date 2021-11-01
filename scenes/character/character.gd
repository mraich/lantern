# script: character

extends Node2D

enum STATE { IDLE, SPELLCAST, THRUST, WALK, SLASH, SHOOT, HURT, DIE, DEAD, RESURRECT, TURN_LEFT_UP, TURN_LEFT_RIGHT, TURN_LEFT_DOWN, TURN_UP_RIGHT, TURN_UP_DOWN, TURN_UP_LEFT, TURN_RIGHT_DOWN, TURN_RIGHT_LEFT, TURN_RIGHT_UP, TURN_DOWN_LEFT, TURN_DOWN_UP, TURN_DOWN_RIGHT, SPINNING_LEFT_RIGHT, SPINNING_UP_RIGHT, SPINNING_RIGHT_RIGHT, SPINNING_DOWN_RIGHT }
enum ANIMATION { IDLE, SPELLCAST, THRUST, WALK, SLASH, SHOOT, HURT, DIE, DEAD, RESURRECT, TURN_LEFT_UP, TURN_LEFT_RIGHT, TURN_LEFT_DOWN, TURN_UP_RIGHT, TURN_UP_DOWN, TURN_UP_LEFT, TURN_RIGHT_DOWN, TURN_RIGHT_LEFT, TURN_RIGHT_UP, TURN_DOWN_LEFT, TURN_DOWN_UP, TURN_DOWN_RIGHT, SPINNING_LEFT_RIGHT, SPINNING_UP_RIGHT, SPINNING_RIGHT_RIGHT, SPINNING_DOWN_RIGHT }
enum DIRECTION { UP, LEFT, DOWN, RIGHT }
enum ATTACK { THRUST, SLASH, SHOOT }

var state = STATE.IDLE
var next_state = null
var animation = ANIMATION.WALK
var attack = ATTACK.SLASH

var _speed_percent = 100
var speed = Vector2(48 / 3.4, 32 / 3.4) * 3

var stuck = false
var old_positions = []

# This is the stage number to send when the hero arrives near this character.
var _on_near_stage_number = null
# Signal to send when the hero is near.
signal on_near_to_character

# A fireball summoned signal.
signal on_fireball_summoned

export(String) var sprite_face = "res://scenes/character/res/hero_001.png" setget _update_sprite_face

export(int) var direction = DIRECTION.RIGHT setget set_direction

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

	# For setting default values and start animating the character.
	set_direction(DIRECTION.RIGHT)
	set_state(STATE.IDLE)
	set_attack(ATTACK.SLASH)
	pass

func set_speed_percent(speed_percent):
	_speed_percent = speed_percent
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
				set_state(STATE.HURT)
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
			if _on_near_stage_number != null:
				emit_signal("on_near_to_character", self, _on_near_stage_number)
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
		set_state(STATE.IDLE)
		pass
	pass

func _on_legs_exit(other):
	stuck = false
	pass

func _process(delta):
	var offset = Vector2(0, 0)
	var speed_scale = 1

	match state:
		STATE.WALK:
			match direction:
				DIRECTION.UP:
					offset.y = -1
					speed_scale = scale.y
				DIRECTION.LEFT:
					offset.x = -1
					speed_scale = scale.x
				DIRECTION.DOWN:
					offset.y = 1
					speed_scale = scale.y
				DIRECTION.RIGHT:
					offset.x = 1
					speed_scale = scale.x

	if not stuck:
		old_positions.push_back(position)
		if old_positions.size() > 2:
			old_positions.pop_front()
		position += speed * delta * offset * _speed_percent / 100 * speed_scale
	else:
		if old_positions.size() > 0:
			position = old_positions.pop_front()
		stuck = false
	pass

func set_on_near_stage_number(on_near_stage_number):
	self._on_near_stage_number = on_near_stage_number
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
		STATE.IDLE, STATE.SPELLCAST, STATE.THRUST, STATE.SLASH, STATE.SHOOT, STATE.HURT, STATE.RESURRECT:
			if state == STATE.SPELLCAST:
				# Telling the outside world that a fireball must be summoned.
				emit_signal("on_fireball_summoned", self, position - Vector2(0, scale.y * 22), direction)
			set_state(STATE.IDLE)
		STATE.TURN_LEFT_UP, STATE.TURN_LEFT_RIGHT, STATE.TURN_LEFT_DOWN, STATE.TURN_UP_RIGHT, STATE.TURN_UP_DOWN, STATE.TURN_UP_LEFT, STATE.TURN_RIGHT_DOWN, STATE.TURN_RIGHT_LEFT, STATE.TURN_RIGHT_UP, STATE.TURN_DOWN_LEFT, STATE.TURN_DOWN_UP, STATE.TURN_DOWN_RIGHT:
			match state:
				STATE.TURN_DOWN_LEFT, STATE.TURN_UP_LEFT, STATE.TURN_RIGHT_LEFT:
					set_direction(DIRECTION.LEFT)
				STATE.TURN_LEFT_UP, STATE.TURN_RIGHT_UP, STATE.TURN_DOWN_UP:
					set_direction(DIRECTION.UP)
				STATE.TURN_UP_RIGHT, STATE.TURN_DOWN_RIGHT, STATE.TURN_LEFT_RIGHT:
					set_direction(DIRECTION.RIGHT)
				STATE.TURN_RIGHT_DOWN, STATE.TURN_LEFT_DOWN, STATE.TURN_UP_DOWN:
					set_direction(DIRECTION.DOWN)
			set_state(STATE.IDLE)
		STATE.SPINNING_LEFT_RIGHT, STATE.SPINNING_UP_RIGHT, STATE.SPINNING_RIGHT_RIGHT, STATE.SPINNING_DOWN_RIGHT:
			set_direction(DIRECTION.DOWN)
			set_state(STATE.DIE)
		STATE.DIE:
			set_direction(DIRECTION.DOWN)
			set_state(STATE.DEAD)

	_update_animation_by_direction()
	pass

# Setting the current animation.
func _set_animation(new_animation):
	animation = new_animation
	pass

# Choosing the animation keeping in mind the direction.
func _update_animation_by_direction():
	if next_state != null:
		state = next_state
		next_state = null

	match state:
		STATE.IDLE:
			_set_animation(ANIMATION.IDLE)
		STATE.SPELLCAST:
			_set_animation(ANIMATION.SPELLCAST)
		STATE.THRUST:
			_set_animation(ANIMATION.THRUST)
		STATE.WALK:
			_set_animation(ANIMATION.WALK)
		STATE.SLASH:
			_set_animation(ANIMATION.SLASH)
		STATE.SHOOT:
			_set_animation(ANIMATION.SHOOT)
		STATE.HURT:
			_set_animation(ANIMATION.HURT)
		STATE.DIE:
			_set_animation(ANIMATION.DIE)
		STATE.DEAD:
			_set_animation(ANIMATION.DEAD)
		STATE.RESURRECT:
			_set_animation(ANIMATION.RESURRECT)
		STATE.TURN_LEFT_UP:
			_set_animation(ANIMATION.TURN_LEFT_UP)
		STATE.TURN_LEFT_RIGHT:
			_set_animation(ANIMATION.TURN_LEFT_RIGHT)
		STATE.TURN_LEFT_DOWN:
			_set_animation(ANIMATION.TURN_LEFT_DOWN)
		STATE.TURN_UP_RIGHT:
			_set_animation(ANIMATION.TURN_UP_RIGHT)
		STATE.TURN_UP_DOWN:
			_set_animation(ANIMATION.TURN_UP_DOWN)
		STATE.TURN_UP_LEFT:
			_set_animation(ANIMATION.TURN_UP_LEFT)
		STATE.TURN_RIGHT_DOWN:
			_set_animation(ANIMATION.TURN_RIGHT_DOWN)
		STATE.TURN_RIGHT_LEFT:
			_set_animation(ANIMATION.TURN_RIGHT_LEFT)
		STATE.TURN_RIGHT_UP:
			_set_animation(ANIMATION.TURN_RIGHT_UP)
		STATE.TURN_DOWN_LEFT:
			_set_animation(ANIMATION.TURN_DOWN_LEFT)
		ANIMATION.TURN_DOWN_UP:
			_set_animation(STATE.TURN_DOWN_UP)
		STATE.TURN_DOWN_RIGHT:
			_set_animation(ANIMATION.TURN_DOWN_RIGHT)
		STATE.SPINNING_LEFT_RIGHT:
			_set_animation(ANIMATION.SPINNING_LEFT_RIGHT)
		STATE.SPINNING_UP_RIGHT:
			_set_animation(ANIMATION.SPINNING_UP_RIGHT)
		STATE.SPINNING_RIGHT_RIGHT:
			_set_animation(ANIMATION.SPINNING_RIGHT_RIGHT)
		STATE.SPINNING_DOWN_RIGHT:
			_set_animation(ANIMATION.SPINNING_DOWN_RIGHT)

	var animation_string = ANIMATION.keys()[animation].to_lower()
	var dir_string = DIRECTION.keys()[direction].to_lower()
	match animation:
		# These animations are affected by the direction.
		ANIMATION.IDLE, ANIMATION.SPELLCAST, ANIMATION.THRUST, ANIMATION.WALK, ANIMATION.SLASH, ANIMATION.SHOOT:
			$animation.play(animation_string + "_" + dir_string)
		# These animations are not affected by the direction.
		ANIMATION.HURT, ANIMATION.DIE, ANIMATION.DEAD, ANIMATION.RESURRECT:
			$animation.play(animation_string)
		# Turning.
		ANIMATION.TURN_LEFT_UP, ANIMATION.TURN_LEFT_RIGHT, ANIMATION.TURN_LEFT_DOWN, ANIMATION.TURN_UP_RIGHT, ANIMATION.TURN_UP_DOWN, ANIMATION.TURN_UP_LEFT, ANIMATION.TURN_RIGHT_DOWN, ANIMATION.TURN_RIGHT_LEFT, ANIMATION.TURN_RIGHT_UP, ANIMATION.TURN_DOWN_LEFT, ANIMATION.TURN_DOWN_UP, ANIMATION.TURN_DOWN_RIGHT:
			$animation.play(animation_string)
		# Spinning.
		ANIMATION.SPINNING_LEFT_RIGHT, ANIMATION.SPINNING_UP_RIGHT, ANIMATION.SPINNING_RIGHT_RIGHT, ANIMATION.SPINNING_DOWN_RIGHT:
			$animation.play(animation_string)
	pass

func is_dying():
	return state == STATE.SPINNING_LEFT_RIGHT || state == STATE.SPINNING_UP_RIGHT || state == STATE.SPINNING_RIGHT_RIGHT || state == STATE.SPINNING_DOWN_RIGHT || state == STATE.DIE

func is_dead():
	return is_dying() || state == STATE.DEAD

func state_changeable():
	return state != STATE.DEAD

func _can_interrupt():
	return !is_dead() || state == STATE.WALK

func turn_left():
	if !_can_interrupt():
		return

	match direction:
		DIRECTION.UP:
			set_state(STATE.TURN_UP_LEFT)
		DIRECTION.RIGHT:
			set_state(STATE.TURN_RIGHT_LEFT)
		DIRECTION.DOWN:
			set_state(STATE.TURN_DOWN_LEFT)
	pass

func turn_up():
	if !_can_interrupt():
		return

	match direction:
		DIRECTION.RIGHT:
			set_state(STATE.TURN_RIGHT_UP)
		DIRECTION.DOWN:
			set_state(STATE.TURN_DOWN_UP)
		DIRECTION.LEFT:
			set_state(STATE.TURN_LEFT_UP)
	pass

func turn_right():
	if !_can_interrupt():
		return

	match direction:
		DIRECTION.LEFT:
			set_state(STATE.TURN_LEFT_RIGHT)
		DIRECTION.UP:
			set_state(STATE.TURN_UP_RIGHT)
		DIRECTION.DOWN:
			set_state(STATE.TURN_DOWN_RIGHT)
	pass

func turn_down():
	if !_can_interrupt():
		return

	match direction:
		DIRECTION.LEFT:
			set_state(STATE.TURN_LEFT_DOWN)
		DIRECTION.UP:
			set_state(STATE.TURN_UP_DOWN)
		DIRECTION.RIGHT:
			set_state(STATE.TURN_RIGHT_DOWN)
	pass

func go_left():
	if !_can_interrupt():
		return

	if direction == DIRECTION.LEFT:
		set_state(STATE.WALK)
	else:
		turn_left()
	pass

func go_up():
	if !_can_interrupt():
		return

	if direction == DIRECTION.UP:
		set_state(STATE.WALK)
	else:
		turn_up()
	pass

func go_right():
	if !_can_interrupt():
		return

	if direction == DIRECTION.RIGHT:
		set_state(STATE.WALK)
	else:
		turn_right()
	pass

func go_down():
	if !_can_interrupt():
		return

	if direction == DIRECTION.DOWN:
		set_state(STATE.WALK)
	else:
		turn_down()
	pass

func slash():
	set_state(STATE.SLASH)
	pass

func hurt():
	set_state(STATE.HURT)
	pass

func set_attack(new_attack):
	attack = new_attack
	pass

func set_attack_slash():
	set_attack(ATTACK.SLASH)
	pass

func set_attack_shoot():
	set_attack(ATTACK.SHOOT)
	pass

func set_attack_thrust():
	set_attack(ATTACK.THRUST)
	pass

func attack():
	match attack:
		ATTACK.SLASH:
			set_state(STATE.SLASH)
			pass
		ATTACK.SHOOT:
			set_state(STATE.SHOOT)
			pass
		ATTACK.THRUST:
			set_state(STATE.THRUST)
			pass
	pass

func spellcast():
	set_state(STATE.SPELLCAST)
	pass

func stop():
	set_state(STATE.IDLE)
	pass

func die():
	match direction:
		DIRECTION.LEFT:
			set_state(STATE.SPINNING_LEFT_RIGHT)
		DIRECTION.UP:
			set_state(STATE.SPINNING_UP_RIGHT)
		DIRECTION.RIGHT:
			set_state(STATE.SPINNING_RIGHT_RIGHT)
		DIRECTION.DOWN:
			set_state(STATE.SPINNING_DOWN_RIGHT)
	pass
