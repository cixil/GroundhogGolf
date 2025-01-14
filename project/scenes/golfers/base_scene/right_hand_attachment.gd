extends BoneAttachment3D
class_name Holdable

enum objects {None, Club, Ball}


@onready var golf_club: Node3D = $GolfClub
@onready var golf_ball: Node3D = $GolfBall

func _ready():
	show_obj(objects.None)


func show_obj(obj:objects):
	golf_ball.hide()
	golf_club.hide()
	match obj:
		objects.Club:
			golf_club.show()
		objects.Ball:
			golf_ball.show()
