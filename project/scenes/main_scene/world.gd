extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TaskList.game_started = true # enable pause menu
	Audio.start_game()
	
	# update settings if they were set in the start menuwwww
	Settings.emit_setting_signals()
