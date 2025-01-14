extends State

var anim_speed := 3.5
var tee:GolfTee

enum states {shock, walking, picking_up}
var state:states

func enter(args=[]):
	tee = args[0]
	state = states.shock
	pivot.basis = Basis.looking_at(tee.global_position)
	animation_player.play('scared', -1, anim_speed )
	await animation_player.animation_finished
	state = states.walking
	animation_player.play('walking-forward')

func phys_update(_delta):
	match state:
		states.walking:
			var target = tee.global_position
			if body.global_position.distance_squared_to(target) > 1:
				var direction =  body.global_position.direction_to(target)
				body.velocity = body.walk_speed * direction
				pivot.basis = Basis.looking_at(direction)
				body.move_and_slide()
			else:
				state = states.picking_up
				# TODO waiting on animation
				#animation_player.play('pick-up')
				animation_player.stop()
				tee.reset()
				state_ended.emit()
