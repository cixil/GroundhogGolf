extends TextureRect
class_name Slide

signal animation_finished

func play():
	show()
	$AnimationPlayer.stop()
	$AnimationPlayer.play('show-slide')
	
	await $AnimationPlayer.animation_finished
	animation_finished.emit()
