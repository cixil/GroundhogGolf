extends Node


# emitted every time a dirt lump gets raised
signal lump_raised_at(pos:Vector3)
signal hog_left_ground_at(pos:Vector3)

signal golf_tee_fell(tee:GolfTee)

# This is an attempted hit at the ball
signal golfer_swung(golfer:Golfer)
signal golf_ball_hit_by_golfer()

signal radio_turned_on
signal radio_turned_off


#### Added for audio #####
signal hog_entered_dirt
signal hog_exited_dirt
signal hog_started_walking
signal hog_stopped_walking
signal hog_touched_ball
signal golfer_tripped
signal golfer_swung_no_arg
signal bush_moved
signal table_broke

signal crate_pushed_from_ground
signal hog_entered_crate
signal hog_left_crate

## Tasks
signal missed_the_shot
signal outfit_ruined
signal balls_everywhere
signal purple_ball_in_lake
signal employee_dance_off
signal wine_spilled
