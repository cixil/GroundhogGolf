extends RigidBody3D
class_name GolfBall

@export var tee:GolfTee
@export var hole:Node3D
@export var golfer:Golfer

@export var is_purple := false

var force := 1
var on_tee := false
var hit_impulse:Vector3
var initial_pos:Vector3

func _ready():
	initial_pos = global_position
	if hole:
		assert(tee)
		var direction = global_position.direction_to(hole.global_position)
		hit_impulse = (direction + Vector3(0, 2, 0)) * force
		Signals.golfer_swung.connect(_hit)

func disable():
	$CollisionShape3D.disabled = true
	hide()


func reset_position(pos:Vector3=initial_pos):
	$CollisionShape3D.set_deferred('disabled', false)
	global_position = pos
	show()

func _hit(person:Golfer):
	if person == golfer:
		if on_tee:
			Signals.golf_ball_hit_by_golfer.emit()
			apply_central_impulse(hit_impulse)

## falling out of hand when golfer trips
func fell_from_golfer(direction:Vector3):
	var force:float = 0.1
	#print(direction)
	# TODO fixaw 
	#apply_central_impulse(direction*force)

func boop(direction:Vector3):
	hit_from_gopher(direction)

func push_from_gopher(direction:Vector3):
	var force:float = 0.1
	#direction.y = 0
	#direction = direction.normalized()
	apply_central_impulse(direction*force)

func hit_from_gopher(direction:Vector3):
	Signals.hog_touched_ball.emit()
	apply_impulse((direction*0.5 + Vector3(0,0.2,0)))


func _on_tee_detector_body_entered(body: Node3D) -> void:
	# TODO very bad coding practice, didn't have time to fix
	if body.get_parent() == tee:
		on_tee = true

func _on_tee_detector_body_exited(body: Node3D) -> void:
	if body.get_parent() == tee:
		on_tee = false
