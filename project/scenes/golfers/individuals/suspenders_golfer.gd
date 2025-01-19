extends Golfer

@export var ball_to_monitor:GolfBall

func _ready() -> void:
	hold_in_hand(Holdable.objects.Club)
	state_machine.start('idle')

	Signals.golf_ball_hit_by_golfer.connect(_watch_ball)

#func get_hand_pos() -> Transform3D:
	#return skeleton.get_bone_global_pose(13)

func _watch_ball():
	state_machine.transition_to('watchball', [ball_to_monitor])


func _on_watch_ball_state_ended() -> void:
	state_machine.transition_to('idle')
