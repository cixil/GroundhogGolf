extends Slide
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#signal animation_finished
func play():
	show()
	animation_player.play('show')
	await animation_player.animation_finished
	animation_finished.emit()
