extends Area3D

# this just exists to mark the "balls everywhere" task complete

var balls:Array[GolfBall]

var threshhold = 15

func _on_body_entered(body: Node3D) -> void:
	if body is GolfBall:
		if not body in balls:
			balls.append(body)
			if len(balls) > threshhold:
				Signals.balls_everywhere.emit()


func _on_body_exited(body: Node3D) -> void:
	if body is GolfBall:
		balls.erase(body)
