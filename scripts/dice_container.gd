#script: dice_container

extends HBoxContainer

const _DICE_COUNT = 6
const _dice_class = preload("res://scenes/dice.tscn")

func _ready():
	for n in range(0, _DICE_COUNT):
		var dice = _dice_class.instance()
		add_child(dice)
	pass
