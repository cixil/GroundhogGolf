extends MarginContainer
class_name TaskItemControl

@onready var label: RichTextLabel = $RichTextLabel

#@export var start_color:Color
@export var accomplished_color:Color

func set_text(text:String):
	label.text = text

func set_done():
	label.text = "[i][s]" + label.text #+ "[\\i][\\s]"
	label.add_theme_color_override('default_color', accomplished_color)
