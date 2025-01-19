extends Control

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton

@export var game:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.play_intro()
	start_button.grab_focus()
	
	# We lose focus if we open the task menu, so put it back on settings when its closed
	TaskList.task_list_closed.connect(func (): settings_button.grab_focus())
	
	get_tree().get_root().size_changed.connect(resize) 
	resize()

func resize():
	for button in [start_button, settings_button]:
		button.custom_minimum_size.x = get_rect().size.x/4
		button.custom_minimum_size.y = get_rect().size.y/7




func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)


func _on_settings_button_pressed() -> void:
	TaskList.show_menu(true)
