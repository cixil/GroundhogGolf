extends Slide

#signal animation_finished
func play():
	show()
	await get_tree().create_timer(2).timeout
	animation_finished.emit()
