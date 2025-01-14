extends State

var ball:GolfBall

func init():
	animation_player.animation_finished.connect(_animation_finished)


func enter(args=[]):
	ball = args[0]
	animation_player.play('look in future')

func proc_update(_delta) -> void:
	var direction = ball.global_position
	direction.y = 0
	pivot.basis = Basis.looking_at(direction)

func _animation_finished(anim):
	match anim:
		"look in future":
			state_ended.emit()
