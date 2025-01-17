extends Node3D
class_name GolfTee
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var fallen := false

func fall():
	if not fallen:
		fallen = true
		
		animation_player.play("fall")

func reset():
	animation_player.play("fall")
	animation_player.stop()
	fallen = false

func _on_hog_detector_body_entered(body: Node3D) -> void:
	if body is GroundHog:
		if body.current_mode == GroundHog.mode.dig:
			fall()


func _on_golf_ball_detector_body_exited(body: Node3D) -> void:
	if body is GolfBall:
		Signals.golf_tee_fell.emit(self)
