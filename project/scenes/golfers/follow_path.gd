extends State

var current_follower:PathFollow3D
var points:PackedVector3Array
var idx := 0
var target:Vector3

const move_speed = 1
@onready var pivot: Node3D = $"../../Pivot"


func enter(args:Array = []):
	var path:Path3D = args[0]
	assert(path)
	
	current_follower = PathFollow3D.new()
	path.add_child(current_follower)
	
	points = path.curve.get_baked_points()
	idx = 0
	target = points[idx]
	
	owner.call_deferred('reparent', current_follower)
	animation_player.play('walking-forward')

#func _exit_tree() -> void:
	#current_follower.get_parent

func phys_update(delta: float) -> void:
	#current_follower.progress += delta*move_speed
	if body.global_position.distance_squared_to(target) < 1.3:
		idx = (idx + 1) % len(points)
		target = points[idx]
		
	#var angle = Vector3(0,0,1).signed_angle_to(body.direction, Vector3(0,1,0))
	#print('angle z ', angle)
	var direction = body.global_position.direction_to(target).normalized()
	body.direction = direction
	pivot.basis = Basis.looking_at(direction)
	body.velocity = move_speed*direction
	
	
	body.move_and_slide()
