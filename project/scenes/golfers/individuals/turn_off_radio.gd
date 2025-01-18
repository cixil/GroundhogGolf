extends State

var radio:Radio

var reached_target:bool
var pick_up_anim_offset := 2.2
var pick_up_speed = 2
var yell_direction:Vector3

func init():
	animation_player.animation_finished.connect(_on_animation_finished)
	Signals.radio_turned_off.connect(_radio_was_turned_off)

func enter(args=[]):
	radio = args[0]
	yell_direction = args[1]
	
	reached_target = false
	
	pivot.basis = Basis.looking_at(radio.global_position)
	animation_player.play("scared")
	await animation_player.animation_finished

func phys_update(_delta):
	if reached_target: return
	
	var target:Vector3 = radio.global_position
	
	if body.global_position.distance_squared_to(target) > .3:
		body.move_to(target)
	else:
		reached_target = true
		animation_player.play("pick-up", -1, pick_up_speed)
		_turn_off_radio()

func _turn_off_radio():
		await get_tree().create_timer(pick_up_anim_offset/pick_up_speed).timeout
		radio.on = false

# react if radio was turned of by groundhog
func _radio_was_turned_off():
	if not active: return
	if reached_target: return # if reached the target then we turned off the radio
	
	reached_target = true
	animation_player.play("idle-standing")

func _on_animation_finished(anim:String):
	if not active: return
	match anim:
		"pick-up":
			pivot.basis = Basis.looking_at(yell_direction)
			animation_player.play("yelling")
		"yelling", "idle-standing":
			state_ended.emit()
		
