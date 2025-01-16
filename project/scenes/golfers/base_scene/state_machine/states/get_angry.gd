extends State


func enter(_args=[]):
	play()

func play():
	Signals.missed_the_shot.emit()
	animation_player.play('defeated')
