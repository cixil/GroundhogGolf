extends RigidBody3D
class_name Radio

var _golfers:Array[Golfer]

# TODO make audio3d node play from position

var on := false:
	set(value):
		on = value
		if on:
			_turn_on()
		else:
			_turn_off()

func _turn_on():
	Signals.radio_turned_on.emit()
	for golfer in _golfers:
		golfer.notice_radio(self)

func _turn_off():
	Signals.radio_turned_off.emit()
	# above signal will tell golfers
	#for golfer in _golfers:
		#golfer.notice_radio_turned_off(self)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Golfer:
		if body.receptive_to_radio and body not in _golfers:
			_golfers.append(body)
			if on:
				body.notice_radio(self)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body in _golfers:
		_golfers.erase(body)


func _on_hog_detector_body_entered(body: Node3D) -> void:
	pass


func boop(_direction):
	on = !on
