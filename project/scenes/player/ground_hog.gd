extends CharacterBody3D
class_name GroundHog

@onready var pivot: Node3D = $Pivot
@onready var dirt_particles: CPUParticles3D = %DirtParticles
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var dig_effects: Node3D = $DigEffects
@onready var lump_raise_interval: Timer = %LumpRaiseInterval
@onready var animation_player: AnimationPlayer = $"Pivot/ground-hog/AnimationPlayer"
@onready var ball_detector_collision: CollisionShape3D = %BallDetectorCollision


# Different speeds so it looks more normal with the camera angle
var walk_speed_x = .7
var dig_speed_x = 1.5
var speed_z = 2
# The downward acceleration when in the air, in meters per second squared.
var fall_acceleration = 2
var jump_impulse = 5

var _target_velocity = Vector3.ZERO
var _prev_direction:Vector3 = Vector3.ZERO

enum mode {
	dig, 
	walk, 
	transition, 
	pending_walk  # awaiting walk transition but theres currently an obstacle above us
	}
var current_mode = mode.walk

var can_emerge := true

func _ready():
	_tx_to_walk()

func _tx_to_dig():
	Signals.hog_stopped_walking.emit()
	ball_detector_collision.set_deferred('disabled', true)
	_target_velocity.y = 0 # stop falling velocity if there is any
	current_mode = mode.transition
	pivot.hide()
	dig_effects.show()
	#collision.set_deferred('disabled', true)
	dirt_particles.emitting = true
	set_collision_mask_value(1, false)
	current_mode = mode.dig
	lump_raise_interval.start()
	Signals.hog_entered_dirt.emit()

func _tx_to_walk():
	if _prev_direction != Vector3.ZERO:
		Signals.hog_started_walking.emit()
	
	ball_detector_collision.set_deferred('disabled', false)

	current_mode = mode.transition
	pivot.show()
	dirt_particles.emitting = false
	dig_effects.hide()
	#collision.set_deferred('disabled', false)
	set_collision_mask_value(1, true)
	current_mode = mode.walk
	lump_raise_interval.stop()
	Signals.hog_exited_dirt.emit()


func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z += 1
	
	# turn mesh toward input direction
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
		
		
	if Input.is_action_pressed("stand"):
		animation_player.play("stand")
		return
	elif is_on_floor() and Input.is_action_just_pressed("dig"):
		_tx_to_dig()
	elif Input.is_action_just_released("dig"):
		if can_emerge:
			_tx_to_walk()
		else:
			current_mode = mode.pending_walk
	
	
	match current_mode:
		mode.dig, mode.pending_walk:
				dirt_particles.emitting = direction != Vector3.ZERO
				_target_velocity.x = direction.x * dig_speed_x
				_target_velocity.z = direction.z * (dig_speed_x + 0.5)
		mode.walk:
			if direction == Vector3.ZERO:
				if _prev_direction != direction:
					Signals.hog_stopped_walking.emit()
				animation_player.play('idle')
			else:
				if _prev_direction == Vector3.ZERO:
					Signals.hog_started_walking.emit()
				animation_player.play('walk')
			if not is_on_floor(): # If in the air, fall towards the floor.
				_target_velocity.y = _target_velocity.y - (fall_acceleration * delta * (-get_gravity().y))
			
			_target_velocity.x = direction.x * walk_speed_x
			_target_velocity.z = direction.z * (walk_speed_x + 0.5)
	
	# Ground Velocity
	# Vertical velocity
	#if is_on_floor() and Input.is_action_just_pressed("dig"):
		#_target_velocity.y = jump_impulse
	
	#
	# Moving the Character
	velocity = _target_velocity
	move_and_slide()
	var collision:KinematicCollision3D = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider is GolfBall:
			pass
			# Todo if hitting ball is separate button, could make this just pushing it
			#collider.apply_impulse((_target_velocity.normalized()*0.1 + Vector3(0,0.15,0)))
	_prev_direction = direction


func _on_lump_raise_interval_timeout() -> void:
	Signals.lump_raised_at.emit(global_position)


func _on_obstacle_detector_body_entered(body: Node3D) -> void:
	can_emerge = false

func _on_obstacle_detector_body_exited(body: Node3D) -> void:
	can_emerge = true
	if current_mode == mode.pending_walk:
		_tx_to_walk()


func _on_golf_ball_detector_body_entered(body: Node3D) -> void:
	if body is GolfBall:
		body.hit_from_gopher(_target_velocity.normalized())
