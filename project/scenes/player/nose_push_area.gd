extends Area3D

var objects:Array[Node3D]
@export var hog:GroundHog

func booped():
	for node in objects:
		node.boop(hog.global_position.direction_to(node.global_position))


func _on_body_entered(body: Node3D) -> void:
	if body is GolfBall or body is Radio or body.is_in_group("boopable"):  # better to use a group for all of these but no time
		objects.append(body)


func _on_body_exited(body: Node3D) -> void:
	if body in objects:
		objects.erase(body)
