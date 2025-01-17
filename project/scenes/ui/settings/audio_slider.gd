extends Control

@export var label_text:String
@export var bus_name:String
@export var initial_value:float

@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var h_slider: HSlider = $MarginContainer/HBoxContainer/HSlider
@onready var panel: Panel = $Panel

var _bus_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bus_index = AudioServer.get_bus_index(bus_name)
	label.text = label_text 
	h_slider.value = initial_value
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(initial_value))


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))


func _process(delta: float) -> void:
	if not has_focus():
		return
	if Input.is_action_pressed("move_left"):
		h_slider.value -= h_slider.step *5
	if Input.is_action_pressed("move_right"):
		h_slider.value += h_slider.step*5


func _on_focus_entered() -> void:
	panel.focus()


func _on_focus_exited() -> void:
	panel.unfocus()
