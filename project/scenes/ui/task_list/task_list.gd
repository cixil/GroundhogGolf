extends Control

@onready var item_container: VBoxContainer = %ItemContainer

@export var task_item_scene:PackedScene

var tasks = [
	["Make him miss the shot", Signals.missed_the_shot , false],
	["Ruin someone's outfit", Signals.outfit_ruined, false],
	["Balls everywhere", Signals.balls_everywhere, false]
]


func _ready() -> void:
	for i in len(tasks):
		var text:String = tasks[i][0]
		var trigger:Signal = tasks[i][1]
		
		var task_item:TaskItemControl = task_item_scene.instantiate()
		item_container.add_child(task_item)
		task_item.set_text(text)
		trigger.connect(mark_done.bind(i))
	
	hide()

func mark_done(index:int):
	tasks[index][2] = true
	var item:TaskItemControl = item_container.get_child(index)
	item.set_done()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			get_tree().paused = false
			hide()
		else:
			show()
			get_tree().paused = true