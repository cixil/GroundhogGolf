extends Golfer


func _ready():
	super()
	if path_to_follow:
		trippable = true
		state_machine.start("FollowPath", [path_to_follow, path_point_animations])
