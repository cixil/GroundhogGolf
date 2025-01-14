extends Node


# emitted every time a dirt lump gets raised
signal lump_raised_at(pos:Vector3)

signal golf_tee_fell(tee:GolfTee)

# This is an attempted hit at the ball
signal golfer_swung(golfer:Golfer)


#### Added for audio #####
signal hog_entered_dirt
signal hog_exited_dirt
signal hog_started_walking
signal hog_stopped_walking
signal hog_touched_ball
signal golfer_tripped
