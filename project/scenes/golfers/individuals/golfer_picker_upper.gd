extends Golfer

#@onready var animation_player: AnimationPlayer = %AnimationPlayer
#@onready var state_machine: Node = $StateMachine
#@onready var hand: Holdable = %BoneAttachment3D
## Default home position to return to
#var home_position:Vector3

## If set, will fix the tee after hoggo knocks it over
@export var tee_to_monitor:GolfTee
@export var ball_to_monitor:GolfBall

signal reset_ball


func _ready() -> void:
	super()
	if tee_to_monitor:
		Signals.golf_tee_fell.connect(_on_tee_fell)
	
	Signals.golf_ball_hit_by_golfer.connect(_watch_ball)
	state_machine.start('idle')

#func get_hand_pos() -> Transform3D:
	#return skeleton.get_bone_global_pose(13)

func _watch_ball():
	state_machine.transition_to('watchball', [ball_to_monitor])

func _on_tee_fell(tee:GolfTee):
	if tee == tee_to_monitor:
		state_machine.transition_to('resettee', [tee, ball_to_monitor, true])



func _on_lump_detector_body_entered(_body: Node3D) -> void:
	if animation_player.current_animation == 'walking-forward':
		state_machine.transition_to('trip', [ball_to_monitor])

# TODO need to return to the last state not follow path

func _on_trip_state_ended() -> void:
	state_machine.transition_to('resettee', [tee_to_monitor, ball_to_monitor, false])


func _on_reset_tee_state_ended() -> void:
	state_machine.transition_to('gotoposition', [home_position])
	await $StateMachine/GoToPosition.state_ended
	pivot.basis = Basis.looking_at(tee_to_monitor.global_position)
	reset_ball.emit()


func _on_watch_ball_state_ended() -> void:
	state_machine.transition_to('resettee', [tee_to_monitor, ball_to_monitor, false])
