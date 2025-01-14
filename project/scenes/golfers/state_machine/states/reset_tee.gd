extends State

var anim_speed := 3.5
var tee:GolfTee

enum states {shock, walking, picking_up}
var state:states

var pick_up_anim_offset := 2.4

func init():
	animation_player.animation_finished.connect(_animation_finished)

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
			if body.global_position.distance_squared_to(target) > 0.2:
				var direction =  body.global_position.direction_to(target)
				body.velocity = body.walk_speed * direction
				pivot.basis = Basis.looking_at(direction)
				body.move_and_slide()
			else:
				state = states.picking_up
				animation_player.play('pick-up')
				await get_tree().create_timer(pick_up_anim_offset).timeout
				tee.reset()



func _animation_finished(anim:String):
	match anim:
		'pick-up':
				state_ended.emit()
