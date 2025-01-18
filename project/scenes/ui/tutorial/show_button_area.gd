extends Area3D

@export var text_to_show:String

signal hog_entered(text:String)
signal hog_exited

func _on_body_entered(body: Node3D) -> void:
	if body is GroundHog:
		hog_entered.emit(text_to_show)

func _on_body_exited(body: Node3D) -> void:
	if body is GroundHog:
		hog_exited.emit()
