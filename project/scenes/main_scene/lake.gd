extends Area3D

var balls:Array[GolfBall]

func _on_body_entered(body: Node3D) -> void:
	if body is GolfBall:
		Signals.golfball_in_lake.emit()
		if body.is_purple:
			balls.append(body)
			Signals.purple_ball_in_lake.emit()

func _on_body_exited(body: Node3D) -> void:
	if body is GolfBall:
		if body.is_purple:
			if body in balls:
				balls.erase(body)
			#Signals.purple_ball_in_lake.emit()
