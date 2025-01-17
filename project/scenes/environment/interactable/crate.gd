extends RigidBody3D


func _on_inside_crate_body_entered(body: Node3D) -> void:
	if body is GroundHog:
		print('in_crate')
		body.in_crate = true

func _on_inside_crate_body_exited(body: Node3D) -> void:
	if body is GroundHog:
		print('not in crate')
		body.in_crate = false
