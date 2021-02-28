# script:: bar

extends Node2D

func _ready():
	switch(false)
	pass

func fade():
	$animation.play("fade")
	pass

func switch(is_on):
	$sprite_on.visible = is_on
	$sprite_off.visible = not is_on
	pass

func get_width():
	return 10 * scale.x

func get_height():
	return 10 * scale.y

func is_on():
	return $sprite_on.visible
