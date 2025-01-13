extends State
@onready var skeleton_3d: Skeleton3D = %Skeleton3D
@onready var pivot: Node3D = $"../../Pivot"

# TODO make golfer in right position when falling so he gets up in right pos
# also after seeking need to reset position

const move_speed = 1.0

var speed = 1

func init() -> void:
	animation_player.animation_finished.connect(_animation_finished)


func enter(arr=[]):
	animation_player.play('falling-face-front', -1, speed)
	animation_player.seek(.43) # start playback right when fall happens
	var distance_to_fall = -0.7
	var angle = Vector3(0,0,1).signed_angle_to(body.direction, Vector3(0,1,0))
	var new_pos:Vector3 = Vector3(0,0,distance_to_fall).rotated(Vector3(0,1,0), angle)
	body.global_position += new_pos

func _animation_finished(anim_name:String):
	match anim_name:
		'falling-face-front':
			animation_player.play('getting-up', -1, speed)
			
			# the end of the fall animation is different from where the body is
			# move the body to the approximate distance we fell so the skeleton doesn't
			# "jump" back to the original place before the fall
			var distance_to_fall = 3.07
			var angle = Vector3(0,0,1).signed_angle_to(body.direction, Vector3(0,1,0))
			var new_pos:Vector3 = Vector3(0,0,distance_to_fall).rotated(Vector3(0,1,0), angle)
			body.global_position += new_pos
			
		'getting-up':
			state_ended.emit()
