# script: dice_clickable

extends "res://scripts/dice/dice_rollable.gd"

# This signal is for hiding dice_area from the other
# scenes who want to sign up for the click event.
signal on_dice_clicked

func _ready():
	# Setting signal for recognize clicking on the dice area.
	$dice_area.connect("on_dice_clicked", self, "_on_dice_clicked")

	# Sending signal for those who want to receive it.
	# I don't want to send this signal in the _on_dice_clicked
	# function as it is to be overridden in the child scenes and
	# it is not guaranteed that the child scenes
	# in the _on_dice_clicked will call this super function.
	$dice_area.connect("on_dice_clicked", self, "_on_dice_clicked_internal")
	pass

# Inherited scenes will override this function to be notified
# when they were clicked.
func _on_dice_clicked():
	pass

# When someone clicks on this dice we will emit this signal too.
# This is for hiding the dice_area scene from the other scenes.
func _on_dice_clicked_internal():
	emit_signal("on_dice_clicked")
	pass
