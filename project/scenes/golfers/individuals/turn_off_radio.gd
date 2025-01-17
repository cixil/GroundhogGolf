extends State

var radio:Radio

var reached_target:bool
var pick_up_anim_offset := 2.2
var pick_up_speed = 2
var yell_direction:Vector3

func init():
	animation_player.animation_finished.connect(_on_animation_finished)

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
		await get_tree().create_timer(pick_up_anim_offset/pick_up_speed).timeout
		radio.on = false

func _on_animation_finished(anim:String):
	match anim:
		"pick-up":
			pivot.basis = Basis.looking_at(yell_direction)
			animation_player.play("yelling")
		"yelling":
			state_ended.emit()
