extends  Golfer


@export var tee_to_golf:GolfTee

@export var holding:Holdable.objects = Holdable.objects.None

var start_orientation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	start_orientation = pivot.basis
	
	if tee_to_golf:
		Signals.golf_tee_fell.connect(_on_golf_tee_fell)
	
	hold_in_hand(holding)
	
	state_machine.start('golf', [tee_to_golf])


func resume_golfing():
	pivot.basis = start_orientation
	state_machine.transition_to('golf')


func _on_golf_tee_fell(tee:GolfTee):
	if tee == tee_to_golf:
		print($StateMachine/Golf.about_to_swing)
		if state_machine.current_state == $StateMachine/Golf and $StateMachine/Golf.about_to_swing:
			await $StateMachine/Golf.just_swung
			print('get angry')
			state_machine.transition_to("getangry")
		else:
			state_machine.transition_to('noticehog', [tee])


func _on_lump_detector_body_entered(_body: Node3D) -> void:
	if animation_player.current_animation == 'walking-forward':
		state_machine.transition_to('trip')

# TODO need to return to the last state not follow path

func _on_trip_state_ended() -> void:
	return



func _on_golf_state_ended() -> void:
	state_machine.transition_to('idle')
