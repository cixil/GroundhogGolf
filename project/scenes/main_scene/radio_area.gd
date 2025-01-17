extends Area3D
# this area represents all places the radio can be

@export var radio:Radio


func _on_body_entered(body: Node3D) -> void:
		if body is Golfer:
			if body.is_manager:
				Signals.radio_turned_on.connect(body.turn_off_radio.bind(radio))
				if radio.on:
					body.turn_off_radio(radio)


func _on_body_exited(body: Node3D) -> void:
		if body is Golfer:
			if body.is_manager:
				Signals.radio_turned_on.disconnect(body.turn_off_radio)
