extends RigidBody3D
class_name GolfBall

@export var tee:GolfTee
@export var hole:Node3D
@export var golfer:Golfer

var force := 2

var hit_impulse:Vector3

func _ready():
	if hole:
		assert(tee)
		var direction = global_position.direction_to(hole.global_position)
		hit_impulse = (direction + Vector3(0, 2, 0)) * force
		Signals.golfer_swung.connect(_hit)

func _hit(person:Golfer):
	if person == golfer:
		if tee.has_ball:
			apply_impulse(hit_impulse)
