extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is GolfBall:
		if body.is_purple:
			print('gotem')
			Signals.purple_ball_in_hole.emit()
