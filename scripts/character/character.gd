# script: character

extends Node2D

enum STATE { IDLE, SPELLCAST, THRUST, WALK, SLASH, SHOOT, HURT, DIE, DEAD, RESURRECT }
enum ANIMATION { IDLE, SPELLCAST, THRUST, WALK, SLASH, SHOOT, HURT, DIE, DEAD, RESURRECT }
enum DIRECTION { UP, LEFT, DOWN, RIGHT }

var state = STATE.IDLE
var next_state = null
var animation = ANIMATION.WALK
var direction = DIRECTION.LEFT

var speed = Vector2(75, 0)

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
	next_state = new_state
	pass

func set_direction(new_direction):
	direction = new_direction

	# When we turn it ends in the idle state.
	if state != STATE.IDLE:
		set_state(STATE.IDLE)

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
		STATE.DIE:
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

	var animation_string = ANIMATION.keys()[animation].to_lower()
	var dir_string = DIRECTION.keys()[direction].to_lower()
	match animation:
		# These animations are affected by the direction.
		ANIMATION.IDLE, ANIMATION.SPELLCAST, ANIMATION.THRUST, ANIMATION.WALK, ANIMATION.SLASH, ANIMATION.SHOOT:
			$animation.play(animation_string + "_" + dir_string)
		# These animations are not affected by the direction.
		ANIMATION.HURT, ANIMATION.DIE, ANIMATION.DEAD, ANIMATION.RESURRECT:
			$animation.play(animation_string)
	pass
