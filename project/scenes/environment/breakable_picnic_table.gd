extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var emphasis: MeshInstance3D = $Emphasis

var broken := false

func _ready() -> void:
	animation_player.play('break')
	animation_player.stop()

# TODO: no idea why this isn't working ;A;, but you can boop instead
func _on_lump_detector_body_entered(_body: Node3D) -> void:
	break_table()

func break_table():
	if not broken:
		broken = true
		emphasis.queue_free()
		Signals.table_broke.emit()

		animation_player.play('break', -1, 0.6)


func _on_broken_leg_bottom_booped() -> void:
	break_table()
