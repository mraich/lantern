#script: fireball

extends Node2D

var direction = 1

var move = Vector2(300 * 3.4 , 0)

var friend = null

func _ready():
	$animation.current_animation = "flaming"

	$shape.connect("area_exited", self, "_on_area_exited")
	pass

func _on_area_exited(other):
	if friend == other:
		friend = null
		pass
	pass

func _process(delta):
	position += move * delta * direction

	if direction > 0 and position.x > 700:
		position.x = -200
	if direction < 0 and position.x < -200:
		position.x = 700
	pass

func set_direction(new_direction):
	direction = new_direction

	if direction > 0:
		rotation_degrees = 180
	if direction < 0:
		rotation_degrees = 0
	pass
