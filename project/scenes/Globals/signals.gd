extends Node


# emitted every time a dirt lump gets raised
signal lump_raised_at(pos:Vector3)

signal golf_tee_fell(tee:GolfTee)


#### Added for audio #####
signal hog_entered_dirt
signal hog_exited_dirt
signal golfer_tripped