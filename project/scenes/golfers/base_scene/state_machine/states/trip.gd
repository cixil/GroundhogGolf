extends State

# TODO make golfer in right position when falling so he gets up in right pos
# also after seeking need to reset position


var speed = 1
var ball:GolfBall

var start_offset = 0.43
var ball_release_offset = 1.1

func init() -> void:
	animation_player.animation_finished.connect(_animation_finished)


func enter(arg=[]):
	if len(arg) > 0:
		ball = arg[0]
	animation_player.play('falling-face-front', -1, speed)
	#animation_player.seek(start_offset) # start playback right when fall happens
	#var distance_to_fall = -0.7
	#var angle = Vector3(0,0,1).signed_angle_to(body.direction, Vector3(0,1,0))
	#var new_pos:Vector3 = Vector3(0,0,distance_to_fall).rotated(Vector3(0,1,0), angle)
	#body.global_position += new_pos
	Signals.golfer_tripped.emit()
	
	# If holding a ball have it "fall from the hand"
	# this is necessary for the ResetTee state to be resumable after a trip
	if body.holding_object == Holdable.objects.Ball:
		if ball:
			await get_tree().create_timer(ball_release_offset-start_offset)
			ball.reset_position(body.hand.global_position)
			body.hold_in_hand(Holdable.objects.None)
			ball.fell_from_golfer(body.direction) # TODO fix direction

func _exit():
	ball = null

func phys_update(_delta):
	pass

func _animation_finished(anim_name:String):
	match anim_name:
		'falling-face-front':
			if body.in_mud:
				body.get_muddy()
			animation_player.play('getting-up', -1, speed*2)
			
			# the end of the fall animation is different from where the body is
			# move the body to the approximate distance we fell so the skeleton doesn't
			# "jump" back to the original place before the fall
			var distance_to_fall = 3.07
			var angle = Vector3(0,0,1).signed_angle_to(body.direction, Vector3(0,1,0))
			var new_pos:Vector3 = Vector3(0,0,distance_to_fall).rotated(Vector3(0,1,0), angle)
			#body.global_position += new_pos
			

			
		'getting-up':
			state_ended.emit()
