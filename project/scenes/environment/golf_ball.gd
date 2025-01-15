extends RigidBody3D
class_name GolfBall

@export var tee:GolfTee
@export var hole:Node3D
@export var golfer:Golfer

var force := 2.5
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

func reset_position():
	global_position = initial_pos
	$CollisionShape3D.disabled = false
	show()

func _hit(person:Golfer):
	if person == golfer:
		if on_tee:
			Signals.golf_ball_hit_by_golfer.emit()
			apply_impulse(hit_impulse)

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
