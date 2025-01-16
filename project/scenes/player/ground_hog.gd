extends CharacterBody3D
class_name GroundHog

@onready var pivot: Node3D = $Pivot
@onready var dirt_particles: CPUParticles3D = %DirtParticles
#@onready var collision_shape: CollisionShape3D = $CollisionShape3D
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
var jump_impulse = .3

var _target_velocity = Vector3.ZERO
var _prev_direction:Vector3 = Vector3.ZERO
var push_force := 0.1

enum mode {
	dig, 
	walk, 
	transition_to_dig,
	transition_to_walk, 
	pending_walk  # awaiting walk transition but theres currently an obstacle above us
	}
var current_mode = mode.walk

var can_emerge := true
var _on_ground := false

var _used_mask_layers:Array[int] = []

func _ready():
	for i in range(1, 33):
		if get_collision_mask_value(i):
			_used_mask_layers.append(i)
	_tx_to_walk()

func _tx_to_dig():
	current_mode = mode.transition_to_dig
	
	Signals.hog_stopped_walking.emit()
	ball_detector_collision.set_deferred('disabled', true)
	_target_velocity.y = 0 # stop falling velocity if there is any
	
	#animation_player.play('Jump in ground', -1, 2)
	#await animation_player.animation_finished
	
	# toggle dig effects
	pivot.hide()
	dig_effects.show()
	dirt_particles.emitting = true
	
	set_collision_masks(false)
	
	lump_raise_interval.start()
	Signals.hog_entered_dirt.emit()
	current_mode = mode.dig

func set_collision_masks(val:bool):
	var ground_collision := 3
	var underground_collision := 6
	for i in _used_mask_layers:
		if i != ground_collision and i != underground_collision:
			set_collision_mask_value(i, val)


func _tx_to_walk():

	current_mode = mode.transition_to_walk
	if _prev_direction != Vector3.ZERO:
		Signals.hog_started_walking.emit()
	
	ball_detector_collision.set_deferred('disabled', false)
	
	# toggle dig effects
	pivot.show()
	dirt_particles.emitting = false
	dig_effects.hide()
	lump_raise_interval.stop()

	set_collision_masks(true)
	
	animation_player.play('jump out', -1, 2)
	_target_velocity.y = jump_impulse
	await animation_player.animation_finished
	
	
	Signals.hog_exited_dirt.emit()
	current_mode = mode.walk


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
	
	#if current_mode != mode.transition:
	if is_on_floor() and _on_ground and Input.is_action_just_pressed("dig"):
		_tx_to_dig()
	elif current_mode == mode.dig and Input.is_action_just_released("dig"):
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
			
			
			_target_velocity.x = direction.x * walk_speed_x
			_target_velocity.z = direction.z * (walk_speed_x + 0.5)
			
	if not is_on_floor(): # If in the air, fall towards the floor.
		_target_velocity.y = _target_velocity.y - (fall_acceleration * delta * (-get_gravity().y))

	#print('floor ', get_floor_normal())
	#if get_floor_normal() != Vector3.UP:
		#_target_velocity *= 2
		#print(_target_velocity)
	#
	# Moving the Character
	velocity = _target_velocity
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var collider = c.get_collider()
		if collider is RigidBody3D:
			if current_mode == mode.transition_to_walk:
				#print('boom')
				#collider.apply_impulse((-c.get_normal() * push_force + Vector3.UP*20)*delta, c.get_position())
				collider.apply_central_impulse((-c.get_normal() + Vector3.UP) * push_force * delta * 200)
			else:
			
				#collider.apply_force(-c.get_normal() * push_force * delta * 50, c.get_position())
				collider.apply_central_force(-c.get_normal() * push_force * delta * 200)
			
			#print('pushing ', c.get_collider(),' ', c.get_normal().distance_to(Vector3.UP))

	_prev_direction = direction


func _on_lump_raise_interval_timeout() -> void:
	Signals.lump_raised_at.emit(global_position)


func _on_obstacle_detector_body_entered(_body: Node3D) -> void:
	can_emerge = false

func _on_obstacle_detector_body_exited(_body: Node3D) -> void:
	can_emerge = true
	if current_mode == mode.pending_walk:
		_tx_to_walk()


func _on_golf_ball_detector_body_entered(body: Node3D) -> void:
	return 
	#TODO fix
	if body is GolfBall:
		body.hit_from_gopher(_target_velocity.normalized())


func _on_ground_detector_body_entered(body: Node3D) -> void:
	print('on grd')
	_on_ground = true

func _on_ground_detector_body_exited(body: Node3D) -> void:
	print('off grnd')
	_on_ground = false
