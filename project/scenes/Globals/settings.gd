extends Node

var hold_to_dig := true

var show_controls := false

var camera_use_orthographic := true:
	set(value):
		camera_use_orthographic = value
		camera_mode_changed.emit(value)

signal show_controls_changed(value:bool)

signal camera_mode_changed(value:bool)

func emit_setting_signals():
	camera_mode_changed.emit(camera_use_orthographic)
	show_controls_changed.emit(show_controls)
