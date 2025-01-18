extends Node3D
class_name GolfTee
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var fallen := false
var just_hit := false

func _ready() -> void:
	Signals.golf_ball_hit_by_golfer.connect(_hit_cooldown)

func _hit_cooldown():
	just_hit = true
	await get_tree().create_timer(1).timeout
	just_hit = false

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
		print('left')
		if not just_hit:
			Signals.golf_tee_fell.emit(self)
