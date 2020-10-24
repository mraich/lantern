# script: dice_clickable

extends "res://scripts/dice/dice_rollable.gd"

func _ready():
	# Setting signal for recognize clicking on the dice area.
	get_node("dice_area").connect("on_dice_clicked", self, "_on_dice_clicked")
	pass

# Inherited scenes will override this function to be notified
# when they were clicked.
func _on_dice_clicked():
	pass
