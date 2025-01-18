extends Control
@onready var tutorial_label: Label = %TutorialLabel
@onready var tutorial_panel: MarginContainer = $TutorialPanel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var control_panel: MarginContainer = %"Control Panel"


func _ready():
	hide_tutorial_message()
	toggle_control_visibility(false)
	Settings.show_controls_changed.connect(toggle_control_visibility)

func bring_attention_to_tasks():
	pass

func toggle_control_visibility(vis:bool) -> void:
	control_panel.visible = vis

func show_tutorial_message(msg:String):
	tutorial_label.text = msg
	tutorial_panel.show()
	animation_player.play("grab_attention")

func hide_tutorial_message():
	tutorial_panel.hide()
