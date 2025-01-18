extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var emphasis: MeshInstance3D = $Emphasis

var broken := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play('break')
	animation_player.stop()

func _on_lump_detector_body_entered(_body: Node3D) -> void:
	if not broken:
		broken = true
		emphasis.queue_free()
		animation_player.play('break', -1, 0.6)
	
