extends State

var anim_speed := 3.5
var tee:GolfTee
var ball:GolfBall

enum states {shock, walking_to_ball, picking_up_ball, walking_to_tee, picking_up_tee}
var state:states

var pick_up_anim_offset := 2.4

func init():
	animation_player.animation_finished.connect(_animation_finished)

func enter(args=[]):
	tee = args[0]
	ball = args[1]
	var use_shock:bool = args[2]
	
	if use_shock:
		state = states.shock
		pivot.basis = Basis.looking_at(tee.global_position)
		animation_player.play('scared', -1, anim_speed )
		await animation_player.animation_finished
	start_walking_to_ball_state()

func phys_update(_delta):
	match state:
		states.walking_to_ball:
			var target = ball.global_position
			target.y = 0
			if body.global_position.distance_squared_to(target) > 0.2:
				move_to(target)
			else:
				get_ball()
		states.walking_to_tee:
			var target = tee.global_position
			target.y = 0
			if body.global_position.distance_squared_to(target) > 0.2:
				move_to(target)
			else:
				get_tee()

func move_to(target):
	animation_player.play('walking-forward')
	var direction =  body.global_position.direction_to(target)
	body.direction = direction
	body.velocity = body.walk_speed * direction
	pivot.basis = Basis.looking_at(direction)
	body.move_and_slide()

func start_walking_to_ball_state():
	state = states.walking_to_ball
	animation_player.play('walking-forward')

func start_walking_to_tee_state():
	animation_player.play('walking-forward')
	state = states.walking_to_tee

func get_ball():
	state = states.picking_up_ball
	animation_player.play('pick-up', -1, 2.5)
	await get_tree().create_timer(pick_up_anim_offset/2.5).timeout
	body.hold_in_hand(Holdable.objects.Ball)
	ball.disable()

func get_tee():
	state = states.picking_up_tee
	animation_player.play('pick-up')
	await get_tree().create_timer(pick_up_anim_offset).timeout
	body.hold_in_hand(Holdable.objects.None)
	tee.reset()
	ball.reset_position()


func _animation_finished(anim:String):
	match anim:
		'pick-up':
			match state:
				states.picking_up_ball:
					start_walking_to_tee_state()
				states.picking_up_tee:
					state_ended.emit()
