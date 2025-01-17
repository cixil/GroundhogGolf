extends MarginContainer

@onready var music_slider: MarginContainer = %MusicSlider
@onready var sfx_slider: MarginContainer = %SFXSlider


@export_multiline var dig_mode_help_text:String
@export_multiline var cam_mode_help_text:String

signal display_help_text(text:String)
signal disable_help_text

func start():
	music_slider.grab_focus()


func _on_setting_check_box_value_changed(value: bool) -> void:
	Settings.hold_to_dig = value


func _on_setting_check_box_focus_entered() -> void:
	display_help_text.emit(dig_mode_help_text)


func _on_setting_check_box_focus_exited() -> void:
	disable_help_text.emit()


func _on_camera_check_box_value_changed(value: bool) -> void:
	Settings.camera_use_orthographic = value


func _on_camera_check_box_focus_entered() -> void:
	display_help_text.emit(cam_mode_help_text)


func _on_camera_check_box_focus_exited() -> void:
	disable_help_text.emit()
