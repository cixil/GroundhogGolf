extends CharacterBody3D
class_name GroundHog

@onready var pivot: Node3D = $Pivot
@onready var dirt_particles: CPUParticles3D = %DirtParticles
#@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var dig_effects: Node3D = $DigEffects
@onready var lump_raise_interval: Timer = %LumpRaiseInterval
@onready var animation_player: AnimationPlayer = $"Pivot/ground-hog/AnimationPlayer"
@onready var ball_detector_collision: CollisionShape3D = %BallDetectorCollision

@onready var nose_push_area: Area3D = $Pivot/NosePushArea


# Different speeds so it looks more normal with the camera angle
var walk_speed_x = .7
var dig_speed_x = 1.5
var speed_z = 2
# The downward acceleration when in the air, in meters per second squared.
var fall_acceleration = 2
var jump_impulse = .3
var _nose_boop_offset = 0.18

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
var in_crate := false

var _used_mask_layers:Array[int] = []

func _ready():
	for i in range(1, 33):
		if get_collision_mask_value(i):
			_used_mask_layers.append(i)
	_tx_to_walk(false)

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

# use_sound param is just so we can call this function in _ready
func _tx_to_walk(use_sound=true):
	current_mode = mode.transition_to_walk
	if _prev_direction != Vector3.ZERO:
		if use_sound:
			Signals.hog_started_walking.emit()
	
	ball_detector_collision.set_deferred('disabled', false)
	
	# toggle dig effects
	pivot.show()
	dirt_particles.emitting = false
	dig_effects.hide()
	lump_raise_interval.stop()

	
	
	animation_player.play('jump out', -1, 2)
	if use_sound:
		Signals.hog_left_ground_at.emit(global_position)
	_target_velocity.y = jump_impulse
	# wait a short time before setting collisions back so the obstacle clearer
	# can make sure baskets are out of the way
	await get_tree().create_timer(0.05).timeout
	set_collision_masks(true)

	await animation_player.animation_finished
	
	Signals.hog_exited_dirt.emit()
	current_mode = mode.walk


func _physics_process(delta):
	if animation_player.current_animation == 'nose-push':
		return
	
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
	elif Input.is_action_just_pressed("boop"):
		animation_player.play('nose-push')
		await get_tree().create_timer(_nose_boop_offset).timeout
		nose_push_area.booped()
		return
	
	if Settings.hold_to_dig: # hold dig to dig and release to emerge
		if is_on_floor() and _on_ground and Input.is_action_just_pressed("dig"):
			_tx_to_dig()
		elif current_mode == mode.dig and Input.is_action_just_released("dig"):
			if can_emerge:
				_tx_to_walk()
			else:
				current_mode = mode.pending_walk
				
	else: # Whenever dig is pressed, toggle digging/walking
		if Input.is_action_just_pressed("dig"):
			if current_mode == mode.dig:
				if can_emerge:
					_tx_to_walk()
			elif is_on_floor() and _on_ground:
				_tx_to_dig()
			
	
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
				if collider is GolfBall:
					collider.apply_central_impulse((-c.get_normal() + Vector3.UP) * push_force * delta * 20)
				else:
					collider.apply_central_impulse((-c.get_normal() + Vector3.UP) * push_force * delta * 200)
			else:
				if collider is GolfBall:
					collider.push_from_gopher(-c.get_normal())
					#collider.apply_central_force(-c.get_normal() * push_force * delta * 300)
				else:
					#print('colliding at ', c.get_position())
					if not in_crate:
						collider.apply_central_force(-c.get_normal() * push_force * delta * 1800)
					collider.apply_force(c.get_normal() * push_force * delta * 100, c.get_position())
					collider.apply_central_force(-c.get_normal() * push_force * delta * 100)


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


func _on_ground_detector_body_entered(_body: Node3D) -> void:
	_on_ground = true

func _on_ground_detector_body_exited(_body: Node3D) -> void:
	_on_ground = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		'nose-push':
			animation_player.play('idle')
