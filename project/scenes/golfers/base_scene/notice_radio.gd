extends State

@onready var go_to_position: Node = $"../GoToPosition"
@onready var dance: Node = $"../Dance"

func enter(args=[]):
	var radio:Radio = args[0]
	var dancing_spot:Node3D = args[1]
	play(radio, dancing_spot)

func play(radio:Radio, dancing_spot:Node3D):
	body.trippable = false
	pivot.basis = Basis.looking_at(body.global_position.direction_to(radio.global_position))
	animation_player.play("scared")
	await animation_player.animation_finished
	state_machine.transition_to("gotoposition", [dancing_spot.global_position])
	await go_to_position.state_ended
	state_machine.transition_to("dance")
	await dance.state_ended
	body.trippable = true
