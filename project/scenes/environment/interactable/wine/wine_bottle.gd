extends RigidBody3D

@export var broken_bottle_scene:PackedScene
@export var wine_spill_scene:PackedScene

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _on_ground_detector_body_entered(_body: Node3D) -> void:
	collision_shape_3d.set_deferred('disabled', true)
	var broken_botle = broken_bottle_scene.instantiate()
	get_parent().add_child(broken_botle)
	broken_botle.position = position
	broken_botle.basis = basis
	
	var spill = wine_spill_scene.instantiate()
	get_parent().add_child(spill)
	spill.position = position
	spill.position.y = -0.01
	
	Signals.wine_spilled.emit()
	
	queue_free()
