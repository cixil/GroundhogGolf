extends State


var end_practice := 0.3
var slow_speed = 0.5
var anim = 'golf-swing'
var practice_swings = 3

func _ready():
	end_practice /= slow_speed

func enter(args=[]) -> void:
	var tee:GolfTee = args[0]
	pivot.basis = Basis.looking_at(body.global_position.direction_to(tee.global_position))
	start_teeing()

func start_teeing():
	for i in range(practice_swings):
		print('tee')
		await practice_swing()
	real_swing()

func practice_swing():
	animation_player.play(anim, -1, slow_speed)
	await get_tree().create_timer(end_practice).timeout
	animation_player.pause()
	await get_tree().create_timer(0.1).timeout
	animation_player.play(anim, -1, -slow_speed)
	await get_tree().create_timer(end_practice).timeout

func real_swing():
	await get_tree().create_timer(0.2).timeout
	animation_player.play(anim)
