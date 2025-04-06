extends CharacterBody3D 

@export var MAX_SPEED = 10  # Maximum speed for the character's movement.
@export var FRICTION = 16  # Controls how quickly the character slows down when not moving.
@export var JUMP_VELOCITY = 150  # Initial upward velocity when the character jumps.
@export var JOYSTICK_SENSITIVITY = 8

@onready var camera = $Camera 
@onready var flashlight = $Camera/SpotLight  
@onready var animation_tree = $AnimationTree  
@onready var animation_state = animation_tree.get("parameters/playback") 

var mouse_sensitivity = 0.006  # Determines how fast the camera reacts to mouse movement.
var pitch = 0.0  # Tracks the vertical rotation (pitch) of the camera to control its up/down tilt.

func _ready() -> void:
	# Enable the AnimationTree to start playing animations.
	animation_tree.active = true

func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		# Horizontal rotation (yaw) controls the character turning left or right.
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Vertical rotation (pitch) controls the camera looking up or down.
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -1.2, 1.2)  # Clamp the pitch to prevent the camera from flipping.
		
		# Update the camera's X rotation using the clamped pitch value.
		camera.rotation_degrees.x = rad_to_deg(pitch)

	if event.is_action_pressed("toggle_flashlight"):
		# Toggles the flashlight visibility when the corresponding action is pressed.
		flashlight.visible = !flashlight.visible

func _physics_process(delta: float) -> void:
	# This function is called every physics frame to handle character movement and interactions.

	# Apply gravity if the character is not on the floor.
	if not is_on_floor():
		velocity += get_gravity() * delta  # Gravity is added to the Y component of the velocity.

	var right_stick_vector = Input.get_vector("right_joystick_left",
											"right_joystick_right",
											"right_joystick_up",
											"right_joystick_down")
	
	if right_stick_vector != Vector2.ZERO:
		
		var event := InputEventMouseMotion.new()
		event.relative = right_stick_vector * JOYSTICK_SENSITIVITY
		Input.parse_input_event(event)  # Simulate mouse movement

	# Gather input from the keyboard and normalize it for consistent movement.
	var input_vector = Vector2(
		Input.get_action_strength("game_right") - Input.get_action_strength("game_left"),  # Horizontal input.
		Input.get_action_strength("game_down") - Input.get_action_strength("game_up")  # Vertical input.
	).normalized()

	# Handle jumping when the character is on the floor.
	#if is_on_floor() and Input.is_action_just_pressed("game_jump"):
	#	velocity.y = JUMP_VELOCITY  # Set the upward velocity for the jump.

	# Handle movement logic.
	if input_vector != Vector2.ZERO:  # If there is input, the character should move.
		animation_state.travel("Walk")  # Switch to the "Walk" animation.

		var direction_vector = _translate_input_to_camera(input_vector)
		var movement_speed = direction_vector * MAX_SPEED  # Scale the direction by the maximum speed.

		# Smoothly transition the velocity toward the movement speed using linear interpolation (lerp).
		velocity = velocity.lerp(movement_speed, FRICTION * delta)
	else:
		animation_state.travel("Idle")  # If there is no input, play the "Idle" animation.

		# Gradually reduce the velocity to zero for smooth stopping.
		velocity = velocity.lerp(Vector3.ZERO, FRICTION * delta)
	
	# Move the character while allowing it to slide along surfaces.
	move_and_slide()

# Converts a 2D input vector into a 3D direction vector based on the camera's orientation.
func _translate_input_to_camera(input: Vector2) -> Vector3:

	var camera_pos = camera.get_global_transform().basis  # Get the camera's transformation basis.
	var direction = Vector3.ZERO  # Initialize the direction vector.

	# Add the forward/backward component (Z-axis).
	direction += camera_pos.z * input.y

	# Add the left/right component (X-axis).
	direction += camera_pos.x * input.x

	# Ignore any vertical movement (Y-axis) to ensure movement stays on the horizontal plane.
	direction.y = 0

	# Normalize the direction vector to ensure consistent movement speed.
	direction = direction.normalized()
	
	return direction
