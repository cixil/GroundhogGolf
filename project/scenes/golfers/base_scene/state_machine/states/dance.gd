extends State

@export var dance_animation:String

func enter(_args=[]):
	pivot.basis = Basis.looking_at(Vector3.BACK)
	animation_player.play(dance_animation)
	set_off_task_signal()

func set_off_task_signal():
	await get_tree().create_timer(2).timeout
	Signals.employee_dance_off.emit()
