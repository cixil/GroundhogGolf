extends RigidBody3D


func _on_inside_crate_body_entered(body: Node3D) -> void:
	if body is GroundHog:
		body.in_crate = true

func _on_inside_crate_body_exited(body: Node3D) -> void:
	if body is GroundHog:
		body.in_crate = false


func _on_body_entered(body: Node) -> void:
	#print(body)
	if body is ObstacleClearer:
		Signals.crate_pushed_from_ground.emit()


func _on_under_crate_body_entered(body: Node3D) -> void:
	if body is GroundHog:
		Signals.hog_entered_crate.emit()

func _on_under_crate_body_exited(body: Node3D) -> void:
	if body is GroundHog:
		Signals.hog_left_crate.emit()
