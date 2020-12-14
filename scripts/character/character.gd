# script: character

extends Node2D

func _ready():
	# Changing the appearance of the hero.
	$sprite.set_texture(load("res://res/character/hero_001.png"))
	# Choosing the animation.
	$animation.play("walk_right")
	pass
