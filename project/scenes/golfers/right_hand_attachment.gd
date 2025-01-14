extends BoneAttachment3D
class_name Holdable

enum objects {None, Club, Ball}


@onready var golf_club: Node3D = $GolfClub


func show_obj(obj:objects):
	match obj:
		objects.Club:
			golf_club.show()
