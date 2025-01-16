extends Area3D




func _on_body_entered(body: Node3D) -> void:
	return
	if body is Golfer:
		body.in_mud = true


func _on_body_exited(body: Node3D) -> void:
	return
	if body is Golfer:
		body.in_mud = false


func _on_area_entered(area: Area3D) -> void:
	if area is GolferMudDetector:
		area.golfer.in_mud = true

func _on_area_exited(area: Area3D) -> void:
	if area is GolferMudDetector:
		area.golfer.in_mud = false
