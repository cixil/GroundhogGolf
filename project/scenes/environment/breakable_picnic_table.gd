extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play('break')
	animation_player.stop()

func _on_lump_detector_body_entered(_body: Node3D) -> void:
	print('break')
	animation_player.play('break')
	
