extends MarginContainer
@onready var check_box: CheckBox = $MarginContainer/CheckBox
@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label

signal value_changed(value:bool)

@export var text:String

func _ready():
	label.text = text

func _input(event: InputEvent) -> void:
	if not has_focus(): return
	if event.is_action_pressed("ui_enter"):
		check_box.button_pressed = !check_box.button_pressed
		value_changed.emit(check_box.button_pressed)


func _on_focus_entered() -> void:
	panel.focus()


func _on_focus_exited() -> void:
	panel.unfocus()