extends State

var target:Vector3

func enter(args = []) -> void:
	target = args[0]


func phys_update(_delta) -> void:
	if body.global_position.distance_squared_to(target) > .3:
		body.move_to(target)
	else:
		animation_player.stop()
		state_ended.emit()
