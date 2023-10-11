extends CharacterBody3D

@export var pause_menu: PackedScene

@export var MAX_SPEED = 10
@export var FRICTION  = 16

@onready var camera     = $Camera3D
@onready var flashlight = $SpotLight3D

var direction_vector = Vector3.ZERO
var velocity_vector  = Vector3.ZERO

var mouse_sensitivity = 0.006

func _input(event):
	
	if event is InputEventMouseMotion:

		rotate_y(-event.relative.x * mouse_sensitivity)
		
		var x_rotation = -event.relative.y * mouse_sensitivity
		camera.rotate_x(x_rotation)
		camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2)
		
		flashlight.rotate_x(x_rotation)
		flashlight.rotation.x = clamp(flashlight.rotation.x, -1.2,1.2)
		
	if event.is_action_pressed("ui_home"):
		
		var pause_menu_instance = pause_menu.instance()
		get_tree().get_root().call_deferred("add_child", pause_menu_instance)
		
	if event.is_action_pressed("toggle_flashlight"):
		
		flashlight.visible = !flashlight.visible

func _physics_process(delta : float) -> void:
	
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		
		direction_vector = _translate_input_to_camera(input_vector)
		
		velocity_vector.y = 0
		var movement_speed = direction_vector * MAX_SPEED
		velocity_vector = velocity_vector.lerp(movement_speed, FRICTION * delta)
		
	else:
		velocity_vector = Vector3.ZERO
		
	set_velocity(velocity_vector)
	move_and_slide()
	velocity_vector = velocity

func _translate_input_to_camera(input : Vector2) -> Vector3 :
	
	var camera_pos   = camera.get_global_transform().basis
	var direction = Vector3.ZERO 
	
	direction += camera_pos.z * input.y
	direction += camera_pos.x * input.x 
	
	direction.y = 0
	direction = direction.normalized()
	
	return direction
	
	
	
