extends Panel

@export var normal_box:StyleBoxFlat
@export var focus_box:StyleBoxFlat

func _ready():
	unfocus()

func unfocus():
	add_theme_stylebox_override("panel", normal_box)

func focus():
	add_theme_stylebox_override("panel", focus_box)
