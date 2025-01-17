extends State

@export var dance_animation:String

func enter(_args=[]):
	pivot.basis = Basis.looking_at(Vector3.BACK)
	animation_player.play(dance_animation)
