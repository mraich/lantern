# script: dice_clickable

extends "res://scripts/dice/dice_rollable.gd"

func _ready():
	# Setting signal for recognize clicking on the dice area.
	get_node("dice_area").connect("on_dice_clicked", self, "_on_dice_clicked")

	pass

func _on_dice_clicked():
	pass
