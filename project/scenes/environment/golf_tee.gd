extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fall():
	animation_player.play("fall")

func reset():
	animation_player.play("fall")
	animation_player.stop()


func _on_hog_detector_body_entered(body: Node3D) -> void:
	if body is GroundHog:
		if body.current_mode == GroundHog.mode.dig:
			fall()
