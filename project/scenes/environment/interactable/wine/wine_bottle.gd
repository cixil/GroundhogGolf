extends RigidBody3D

@export var broken_bottle_scene:PackedScene
@export var wine_spill_scene:PackedScene
@export var durability:int = 0

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _on_ground_detector_body_entered(_body: Node3D) -> void:
	if durability > 0:
		durability -= 1
		return
	collision_shape_3d.set_deferred('disabled', true)
	var broken_botle = broken_bottle_scene.instantiate()
	get_parent().add_child(broken_botle)
	broken_botle.position = position
	broken_botle.basis = basis
	
	var spill = wine_spill_scene.instantiate()
	get_parent().add_child(spill)
	spill.global_position = global_position
	spill.global_position.y = 0
	
	Signals.wine_spilled.emit()
	
	queue_free()

func boop(direction:Vector3):
	var force:float = 0.5
	direction.y = 1
	apply_central_impulse(direction*force)
