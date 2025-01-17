extends Golfer

## direction in which to scold after turning off radio
@export var yell_to_direction:Node3D

func _ready():
	super()
	if path_to_follow:
		trippable = true
		state_machine.start("FollowPath", [path_to_follow, path_point_animations])

func turn_off_radio(radio:Radio):
	trippable = false
	state_machine.transition_to("turnoffradio", [radio, yell_to_direction.global_position])


func _on_turn_off_radio_state_ended() -> void:
	trippable = true
	state_machine.start("FollowPath", [path_to_follow, path_point_animations])
