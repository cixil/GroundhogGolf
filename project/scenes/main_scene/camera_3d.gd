extends Camera3D

func _ready():
	Settings.camera_mode_changed.connect(_change_camera_mode)

func _change_camera_mode(value:bool):
	if value:
		projection = ProjectionType.PROJECTION_ORTHOGONAL
	else:
		projection = ProjectionType.PROJECTION_PERSPECTIVE
