extends Control

@export var bus_name:String

var _bus_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bus_index = AudioServer.get_bus_index(bus_name)
	


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))
