# script: character

extends Node2D

enum STATE { IDLE, SPELLCAST, THRUST, WALK, SLASH, SHOOT, HURT, DIE, DEAD, RESURRECT, TURN_LEFT_UP, TURN_LEFT_RIGHT, TURN_LEFT_DOWN, TURN_UP_RIGHT, TURN_UP_DOWN, TURN_UP_LEFT, TURN_RIGHT_DOWN, TURN_RIGHT_LEFT, TURN_RIGHT_UP, TURN_DOWN_LEFT, TURN_DOWN_UP, TURN_DOWN_RIGHT, SPINNING_LEFT_RIGHT, SPINNING_UP_RIGHT, SPINNING_RIGHT_RIGHT, SPINNING_DOWN_RIGHT }
enum ANIMATION { IDLE, SPELLCAST, THRUST, WALK, SLASH, SHOOT, HURT, DIE, DEAD, RESURRECT, TURN_LEFT_UP, TURN_LEFT_RIGHT, TURN_LEFT_DOWN, TURN_UP_RIGHT, TURN_UP_DOWN, TURN_UP_LEFT, TURN_RIGHT_DOWN, TURN_RIGHT_LEFT, TURN_RIGHT_UP, TURN_DOWN_LEFT, TURN_DOWN_UP, TURN_DOWN_RIGHT, SPINNING_LEFT_RIGHT, SPINNING_UP_RIGHT, SPINNING_RIGHT_RIGHT, SPINNING_DOWN_RIGHT }
enum DIRECTION { UP, LEFT, DOWN, RIGHT }

var state = STATE.IDLE
var next_state = null
var animation = ANIMATION.WALK
var direction = DIRECTION.LEFT

var speed = Vector2(48, 32)

func _ready():
	# Changing the appearance of the hero.
	$sprite.set_texture(load("res://res/character/hero_001.png"))

	# Listening to know if an amination is finished.
	$animation.connect("animation_finished", self, "_on_anim_finished")

	# For setting default values and start animating the character.
	set_direction(DIRECTION.RIGHT)
	set_state(STATE.IDLE)
	pass

func _process(delta):
	var offset = Vector2(0, 0)

	match state:
		STATE.WALK:
			match direction:
				DIRECTION.UP:
					offset.y = -1
					if position.y < 0:
						position.y = 700
				DIRECTION.LEFT:
					offset.x = -1
					if position.x < -200:
						position.x = 700
				DIRECTION.DOWN:
					offset.y = 1
					if position.y > 700:
						position.y = 0
				DIRECTION.RIGHT:
					offset.x = 1
					if position.x > 700:
						position.x = -200

	position += speed * delta * offset
	pass

func set_state(new_state):
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

func is_dead():
	return state == STATE.SPINNING_LEFT_RIGHT || state == STATE.SPINNING_UP_RIGHT || state == STATE.SPINNING_RIGHT_RIGHT || state == STATE.SPINNING_DOWN_RIGHT || state == STATE.DIE || state == STATE.DEAD

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
