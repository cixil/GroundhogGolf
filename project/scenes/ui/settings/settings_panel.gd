extends MarginContainer

@onready var music_slider: MarginContainer = %MusicSlider
@onready var sfx_slider: MarginContainer = %SFXSlider
@onready var setting_container: VBoxContainer = %SettingContainer
@onready var down_arrow: Sprite2D = %DownArrow
@onready var animation_player: AnimationPlayer = %AnimationPlayer


@export_multiline var dig_mode_help_text:String
@export_multiline var cam_mode_help_text:String

signal display_help_text(text:String)
signal disable_help_text

var active := false

func _ready():
	close()

func start():
	active = true
	animation_player.play('drop-down-indicate', -1, 0.6)

func end():
	close()
	active = false

func open():
	setting_container.show()
	animation_player.stop()
	music_slider.grab_focus()


func close():
	setting_container.hide()

func _input(event: InputEvent) -> void:
	if active:
		if event.is_action_pressed("ui_down"):
			open()
			active = false


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


func _on_show_controls_check_box_value_changed(value: bool) -> void:
	Settings.show_controls_changed.emit(value)
