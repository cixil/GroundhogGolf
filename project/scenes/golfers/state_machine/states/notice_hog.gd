extends State



func enter(args=[]):
	#pivot.basis = Basis.looking_at(tee.global_position)
	play()

func play():
	animation_player.play('scared', -1, 2 )
	await animation_player.animation_finished
	state_ended.emit()
