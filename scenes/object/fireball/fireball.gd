#script: fireball

extends Node2D

enum DIRECTION { UP, LEFT, DOWN, RIGHT }

var direction = DIRECTION.RIGHT

var speed = Vector2(300 * 3.4, 300 * 3.4)
var move = Vector2(0, 0)

var friend = null
var friend_global_position = null

func _ready():
	$animation.play("flaming")

	$shape.connect("area_exited", self, "_on_area_exited")

	$timer.connect("timeout", self, "_on_timer_timeout")
	pass

func _on_area_exited(other):
	if friend == other:
		friend = null
		pass
	pass

func _process(delta):
	position += move * delta * speed
	pass

func set_direction(new_direction):
	direction = new_direction

	match direction:
		DIRECTION.LEFT:
			rotation_degrees = 0
			move = Vector2(-1, 0)
		DIRECTION.DOWN:
			rotation_degrees = 270
			move = Vector2(0, 1)
		DIRECTION.RIGHT:
			rotation_degrees = 180
			move = Vector2(1, 0)
		DIRECTION.UP:
			rotation_degrees = 90
			move = Vector2(0, -1)
	pass

func set_summoner(other):
	friend = other
	friend_global_position = Vector2(other.global_position.x, other.global_position.y)
	pass

func _on_timer_timeout():
	get_parent().remove_child(self)
	pass
