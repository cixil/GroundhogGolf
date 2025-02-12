extends State

var about_to_swing:bool = false
signal just_swung # signal a little earlier than state_ended incase we need to get angry

var end_practice := 0.3
var slow_speed = 0.5
var anim = 'golf-swing'
@export var practice_swings = 3

var original_basis

func _ready():
	end_practice /= slow_speed
func init():
	original_basis = pivot.basis

func enter(_args=[]) -> void:
	pivot.basis = original_basis
	animation_player.play("stretching-neck")
	await animation_player.animation_finished
	pivot.rotate_y(PI*-1.6)
	start_teeing()
	

# TODO change this to use proc_update and timers so it is pausable
# gitches out and still hits even when paused

func start_teeing():
	for i in range(practice_swings):
		if not active: return
		await practice_swing()
	if not active: return
	real_swing()

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
	await get_tree().create_timer(1.2).timeout
	about_to_swing = false
	if not active: return
	#print('swiing ', get_tree().paused)
	just_swung.emit()
	Signals.golfer_swung.emit(body)
	Signals.golfer_swung_no_arg.emit()
	await animation_player.animation_finished
	state_ended.emit()
	
