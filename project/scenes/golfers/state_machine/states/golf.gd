extends State

var about_to_swing:bool = false
signal just_swung # signal a little earlier than state_ended incase we need to get angry

var end_practice := 0.3
var slow_speed = 0.5
var anim = 'golf-swing'
@export var practice_swings = 3

func _ready():
	end_practice /= slow_speed

func enter(args=[]) -> void:
	var tee:GolfTee = args[0]
	pivot.basis = Basis.looking_at(body.global_position.direction_to(tee.global_position))
	start_teeing()

func start_teeing():
	for i in range(practice_swings):
		if not active: return
		await practice_swing()
	if not active: return
	real_swing()
	state_ended.emit()

func practice_swing():
	if not active: return
	animation_player.play(anim, -1, slow_speed)
	if not active: return

	await get_tree().create_timer(end_practice).timeout
	if not active: return

	animation_player.pause()
	if not active: return
	await get_tree().create_timer(0.1).timeout
	if not active: return
	animation_player.play(anim, -1, -slow_speed)
	if not active: return
	await get_tree().create_timer(end_practice).timeout

func real_swing():
	about_to_swing = true
	await get_tree().create_timer(0.2).timeout
	animation_player.play(anim)
	await get_tree().create_timer(1.3).timeout
	about_to_swing = false
	just_swung.emit()
	Signals.golfer_swung.emit(body)
	
