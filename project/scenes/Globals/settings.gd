extends Node

var hold_to_dig := true

var camera_use_orthographic := true:
	set(value):
		camera_use_orthographic = value
		camera_mode_changed.emit(value)

signal camera_mode_changed(value:bool)
