extends Control
@onready var tutorial_label: Label = %TutorialLabel
@onready var tutorial_panel: MarginContainer = $TutorialPanel
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready():
	hide_tutorial_message()

func bring_attention_to_tasks():
	pass

func show_tutorial_message(msg:String):
	tutorial_label.text = msg
	tutorial_panel.show()
	animation_player.play("grab_attention")

func hide_tutorial_message():
	tutorial_panel.hide()
