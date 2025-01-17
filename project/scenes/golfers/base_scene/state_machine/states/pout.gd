extends State

var sadness_time = 2

func init():
	animation_player.animation_finished.connect(_on_animation_finished)

func enter(args=[]):
	var place_to_look:Vector3 = args[0]
	
	# await a little delay
	# if dancing, gives the affect of continually dancing then noticing the music is off
	if len(args) > 1:
		var delay:float = args[1]
		await get_tree().create_timer(delay).timeout
	
	pivot.basis = Basis.looking_at(body.global_position.direction_to(place_to_look))
	animation_player.play("scared")
	

func _on_animation_finished(anim:String):
	if not active: return
	
	match anim:
		"scared":
			animation_player.play("sad-idle")
		"sad-idle":
			# add randomness so they don't leave right at the same time
			await get_tree().create_timer(sadness_time + randf()*2).timeout
			state_ended.emit()
