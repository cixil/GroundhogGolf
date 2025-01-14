extends State

var target:Vector3

func enter(args = []) -> void:
	target = args[0]
	animation_player.play('walking-forward')

func phys_update(_delta) -> void:
	if body.global_position.distance_squared_to(target) > 1:
		var direction =  body.global_position.direction_to(target)
		body.velocity = body.walk_speed * direction
		pivot.basis = Basis.looking_at(direction)
		body.move_and_slide()
	else:
		animation_player.stop()
		state_ended.emit()
