extends Area3D




func _on_body_entered(body: Node3D) -> void:
	if body is Golfer:
		body.in_mud = true


func _on_body_exited(body: Node3D) -> void:
	if body is Golfer:
		body.in_mud = false
