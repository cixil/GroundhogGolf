extends State

var sadness_time = 3

func init():
	animation_player.animation_finished.connect(_on_animation_finished)

func enter(args=[]):
	var place_to_look:Vector3 = args[0]
	
	# await a little delay
	# if dancing, gives the affect of continually dancing then noticing the music is off
	if len(args) > 1:
		var delay:float = args[1]
		await get_tree().create_timer(delay).timeout
	
	# TODO look in direction
	animation_player.play("scared")
	

func _on_animation_finished(anim:String):
	if not active: return
	
	match anim:
		
		"sad-idle":
			await get_tree().create_timer(sadness_time).timeout
			state_ended.emit()
