extends MarginContainer

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	hide()

func display_text(text:String):
	print('show text')
	show()
	label.text = text

func disable():
	hide()


func _on_settings_panel_disable_help_text() -> void:
	disable()
