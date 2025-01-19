extends MarginContainer

@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var small_label: Label = $MarginContainer/VBoxContainer/SmallLabel

func _ready() -> void:
	hide()

func display_text(text:String, small_text:String=""):
	show()
	label.text = text
	small_label.text = small_text

func disable():
	hide()


func _on_settings_panel_disable_help_text() -> void:
	disable()
