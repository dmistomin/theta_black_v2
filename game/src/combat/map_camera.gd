class_name MapCamera
extends Camera

export(float) var move_speed = 0.5
export(float) var zoom_speed = 100.0

# Stores where the camera is wanting to go (based on pressed keys and speed modifier)
var motion := Vector3()

# Stores the effective camera velocity
var velocity := Vector3()

# The initial camera node rotation
var initial_rotation := rotation.y


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_camera_forward"):
		motion.x = -1
	elif Input.is_action_pressed("move_camera_backward"):
		motion.x = 1
	else:
		motion.x = 0

	if Input.is_action_pressed("move_camera_left"):
		motion.z = 1
	elif Input.is_action_pressed("move_camera_right"):
		motion.z = -1
	else:
		motion.z = 0

	if Input.is_action_just_released("move_camera_up"):
		motion.y = 1
	elif Input.is_action_just_released("move_camera_down"):
		motion.y = -1
	else:
		motion.y = 0

	# Normalize motion
	# (prevents diagonal movement from being `sqrt(2)` times faster than straight movement)
	motion = motion.normalized()

	# Speed modifier
	if Input.is_action_pressed("camera_speed"):
		motion *= 2

	# Zoom speed modifier
	if motion.y > 0 or motion.y < 0:
		motion.y *= zoom_speed

	# Add motion, apply friction and velocity
	velocity += motion * move_speed
	velocity *= 0.9
	translation += velocity * delta
