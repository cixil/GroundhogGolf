extends Node

@onready var dirt_enter_sound: AudioStreamPlayer = $DirtEnterSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# this connects the hog_entered_dirt signal to the _on_hog_entered_dirt function
	Signals.hog_entered_dirt.connect(_on_hog_entered_dirt)

func _on_hog_entered_dirt():
	dirt_enter_sound.play()
