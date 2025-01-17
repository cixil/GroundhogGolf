extends State

var current_follower:PathFollow3D
var points:PackedVector3Array
var idx := 0 # index to baked curve generated point
var point_idx := 0 # index to manually placed point
var target:Vector3
var path:Path3D

# if provided should be same length as the amount of points manually drawn in the path
# string names must be blank or match animation names exactly
# will play the provided animation when it gets to the matching point in the path
var path_point_animations:Array[String]


func enter(args:Array = []):
	path = args[0]
	assert(path)
	if len(args) > 1:
		path_point_animations = args[1]
	
	#current_follower = PathFollow3D.new()
	#path.add_child(current_follower)	
	#owner.call_deferred('reparent', current_follower)
	#current_follower.rotation_mode = PathFollow3D.ROTATION_NONE
	
	points = path.curve.get_baked_points()
	idx = 0
	point_idx = 0
	target = points[idx]
	
	

var playing_animation := false

func phys_update(_delta: float) -> void:
	if not playing_animation:
	
		if body.global_position.distance_squared_to(target) < .1:
			idx = (idx + 1) % len(points)
			target = points[idx]
		if body.global_position.distance_squared_to(path.curve.get_point_position(point_idx)) < .1:
			if path_point_animations:
				var animation_name = path_point_animations[point_idx]
				if animation_name:
					playing_animation = true
					animation_player.play(animation_name)
					await animation_player.animation_finished
			point_idx = (point_idx + 1) % path.curve.point_count
			playing_animation = false
			return
		
		animation_player.play('walking-forward')
		var direction = body.global_position.direction_to(target).normalized()
		body.direction = direction
		pivot.basis = Basis.looking_at(direction)
		body.velocity = body.walk_speed*direction
		
		
		body.move_and_slide()
