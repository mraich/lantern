# script: fire

extends Node2D

var _fire_1 = preload("res://scenes/object/fire/res/fire1_64.png")
var _fire_3 = preload("res://scenes/object/fire/res/fire3_64.png")
var _fire_4 = preload("res://scenes/object/fire/res/fire4_64.png")
var _fire_5 = preload("res://scenes/object/fire/res/fire5_64.png")
var _fire_8 = preload("res://scenes/object/fire/res/fire8_64.png")

var _fire_animations = [_fire_1, _fire_3, _fire_4, _fire_5, _fire_8]

var random = RandomNumberGenerator.new()
var animation_count = 0

func _ready():
	random.randomize()

	$animation.connect("animation_finished", self, "_on_animation_finished")

	_set_new_animation()
	$animation.play("fire")
	pass

func _on_animation_finished(anim):
	animation_count -= 1
	if animation_count <= 0:
		_set_new_animation()

	$animation.play("fire")
	pass

func _set_new_animation():
	var new_animation = random.randi_range(0, _fire_animations.size() - 1)

	$sprite.set_texture(_fire_animations[new_animation])

	animation_count = random.randi_range(3, 6)
	pass
