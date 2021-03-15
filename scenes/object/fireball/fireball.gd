#script: fireball

extends Node2D

var direction = 1

var move = Vector2(300 * 3.4 , 0)

var friend = null

func _ready():
	$animation.current_animation = "flaming"

	$shape.connect("area_exited", self, "_on_area_exited")

	$timer.connect("timeout", self, "_on_timer_timeout")
	pass

func _on_area_exited(other):
	if friend == other:
		friend = null
		pass
	pass

func _process(delta):
	position += move * delta * direction
	pass

func set_direction(new_direction):
	direction = new_direction

	if direction > 0:
		rotation_degrees = 180
	if direction < 0:
		rotation_degrees = 0
	pass

func _on_timer_timeout():
	get_parent().remove_child(self)
	pass
