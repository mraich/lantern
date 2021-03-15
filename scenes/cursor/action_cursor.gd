extends "res://scenes/cursor/cursor.gd"

onready var icon_map = {
	1: $icon_container/critical_hit,
	2: $icon_container/counter_attack,
	3: $icon_container/magic_spell,
	4: $icon_container/magic_spell,
	5: $icon_container/constitution
}

func _ready():
	pass

func set_state(new_state):
	.set_state(new_state)

	for child in $icon_container.get_children():
		if icon_map.keys().has(_state) && icon_map[_state] == child:
			child.visible = true
		else:
			child.visible = false
			pass
		pass
	pass
